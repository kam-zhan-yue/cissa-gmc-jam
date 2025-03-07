class_name Arm
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func _draw():
	var godot_blue : Color = Color("478cbf")
	var grey : Color = Color("414042")
	# Four circles for the 2 eyes: 2 white, 2 grey.
	draw_circle(position, 10, godot_blue)
