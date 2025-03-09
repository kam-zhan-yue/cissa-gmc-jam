class_name GameManager
extends Node2D

@onready var ui: UI = %UI
@onready var camera := %Camera as DynamicCamera
@onready var player_one_checkpoint: Area2D = %PlayerOneCheckpoint
@onready var player_two_checkpoint: Area2D = %PlayerTwoCheckpoint

var player_one: Octopus
var player_two: Octopus

const OCTOPUS = preload("res://scenes/octopus.tscn")
const OCTOBOT = preload("res://scenes/octobot.tscn")
const GAME_SETTINGS = preload("res://resources/game_settings.tres")

func _ready() -> void:
	if GAME_SETTINGS.start_immediately:
		start(GAME_SETTINGS.single_player)

func start(single_player: bool) -> void:
	if single_player:
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
	player_one.player_id = 0
	player_two.player_id = 1
	player_one.global_position = player_one_checkpoint.global_position
	player_two.global_position = player_two_checkpoint.global_position

	Game.init(player_one, player_two, camera, player_one_checkpoint, player_two_checkpoint)
	ui.init()
