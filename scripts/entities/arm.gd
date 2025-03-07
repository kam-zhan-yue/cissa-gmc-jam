class_name Arm
extends Node2D

var aim := Vector2.ZERO


func _draw():
	var godot_blue : Color = Color("478cbf")
	draw_circle(position + aim, 10, godot_blue)
