class_name GameManager
extends Node2D

@onready var ui: UI = %UI
@onready var camera := %Camera as DynamicCamera
@onready var player_one_checkpoint: Area2D = %PlayerOneCheckpoint
@onready var player_two_checkpoint: Area2D = %PlayerTwoCheckpoint
@onready var items_holder := %Items as Node2D

var player_one: Octopus
var player_two: Octopus

const OCTOPUS = preload("res://scenes/octopus.tscn")
const OCTOBOT = preload("res://scenes/octobot.tscn")
const GAME_SETTINGS = preload("res://resources/game_settings.tres")

func _ready() -> void:
	if GAME_SETTINGS.start_immediately:
		start(GAME_SETTINGS.start_mode)
	else:
		Game.on_start.connect(start)

func start(mode: Game.Mode) -> void:
	if mode == Game.Mode.SINGLE:
		player_one = OCTOPUS.instantiate() as Octopus
		var octobot = OCTOBOT.instantiate() as Octobot
		player_two = octobot.get_body()
		add_child(player_one)
		add_child(octobot)
	else:
		player_one = OCTOPUS.instantiate() as Octopus
		player_two = OCTOPUS.instantiate() as Octopus
		add_child(player_one)
		add_child(player_two)
	player_one.player_id = Game.PLAYER_ONE
	player_two.player_id = Game.PLAYER_TWO
	player_one.global_position = player_one_checkpoint.global_position
	player_two.global_position = player_two_checkpoint.global_position

	var items: Array[Item] = []
	for child in items_holder.get_children():
		if child is Item:
			items.append(child as Item)
	player_one.init()
	player_two.init()
	Game.init(mode, player_one, player_two, camera, player_one_checkpoint, player_two_checkpoint, items)
	ui.init()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().reload_current_scene()
