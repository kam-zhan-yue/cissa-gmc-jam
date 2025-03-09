class_name Body
extends Node2D

@onready var octopus: Octopus = $".."


func _process(delta: float) -> void:
	var target_direction := octopus.get_direction()
	rotation = atan2(target_direction.y, target_direction.x) - PI * 0.5
