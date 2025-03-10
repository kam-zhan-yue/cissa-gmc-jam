class_name StartGamePopup
extends Control

var showing := true
const GAME_SETTINGS = preload("res://resources/game_settings.tres")
@onready var single_player: Control = %SinglePlayer
@onready var two_player: Control = %TwoPlayer

var selection := 1

func _ready() -> void:
	if GAME_SETTINGS.start_immediately:
		Global.set_inactive(self)

func init() -> void:
	pass

func _process(_delta: float) -> void:
	if not showing:
		return
	if selection == 1 and Input.is_action_just_pressed(Global.get_input(0, 'move_down')):
		hover_two_player()
	elif selection == 0 and Input.is_action_just_pressed(Global.get_input(0, 'move_up')):
		

func hover_two_player() -> void:
	pass

func hover_single_player() -> void:
	pass
