class_name Arm
extends Node2D

var aim := Vector2.ZERO

@onready var hand: Area2D = %Hand

func _get_hand_position() -> Vector2:
	return position + self.aim

func _draw():
	var godot_blue : Color = Color("478cbf")
	draw_circle(_get_hand_position(), 10, godot_blue)
