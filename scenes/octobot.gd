class_name Octobot
extends Node2D

@onready var octopus: Octopus = %Octopus

func get_player() -> Octopus:
	var child = get_child(0) as Octopus
	return child
