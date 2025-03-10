class_name StartGamePopup
extends Control

var showing := true
const GAME_SETTINGS = preload("res://resources/game_settings.tres")
@onready var single_player: Control = %SinglePlayer
@onready var two_player: Control = %TwoPlayer
@onready var tutorial: Button = %Tutorial

const SCALE_FACTOR := 1.2
const ANIM_TIME := 0.1
var selection := SELECTION.ONE

enum SELECTION {
	ONE,
	TWO,
	TUTORIAL
}

func _ready() -> void:
	if GAME_SETTINGS.start_immediately:
		Global.set_inactive(self)
	else:
		_hover_single_player()

func init() -> void:
	pass

func _process(_delta: float) -> void:
	if not showing:
		return

	if Input.is_action_just_pressed(Global.get_input(0, 'move_down')) or Input.is_action_just_pressed(Global.get_input(1, 'move_down')):
		scroll_down()
	elif Input.is_action_just_pressed(Global.get_input(0, 'move_up')) or Input.is_action_just_pressed(Global.get_input(1, 'move_up')):
		scroll_up()
	
	if Input.is_action_just_pressed(Global.get_input(0, 'dash')):
		start_game()

func scroll_up() -> void:
	if selection == SELECTION.TWO:
		_hover_single_player()
	elif selection == SELECTION.TUTORIAL:
		_hover_two_player()

func scroll_down() -> void:
	if selection == SELECTION.ONE:
		_hover_two_player()
	elif selection == SELECTION.TWO:
		_hover_tutorial()

func _cancel() -> void:
	unhover()
	pass

func unhover() -> void:
	selection = 0
	pass

func _hover_single_player() -> void:
	tween_scale(two_player, 1.0)
	tween_scale(single_player, SCALE_FACTOR)
	selection = SELECTION.ONE


func _hover_two_player() -> void:
	tween_scale(single_player, 1.0)
	tween_scale(tutorial, 1.0)
	tween_scale(two_player, SCALE_FACTOR)
	selection = SELECTION.TWO

func _hover_tutorial() -> void:
	tween_scale(two_player, 1.0)
	tween_scale(tutorial, SCALE_FACTOR)
	selection = SELECTION.TUTORIAL
	


func _on_single_player_button_down() -> void:
	Game.start_single_player()
	Global.set_inactive(self)


func _on_two_player_button_down() -> void:
	Game.start_two_player()
	Global.set_inactive(self)


func _on_tutorial_button_down() -> void:
	Game.start_tutorial()
	Global.set_inactive(self)

func start_game() -> void:
	if selection == SELECTION.ONE:
		_on_single_player_button_down()
	elif selection == SELECTION.TWO:
		_on_two_player_button_down()
	else:
		_on_tutorial_button_down()

func tween_scale(node: Control, scale_factor: float) -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(node, "scale", Vector2.ONE * scale_factor, ANIM_TIME).set_ease(Tween.EASE_IN_OUT)
