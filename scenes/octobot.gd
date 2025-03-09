class_name Octobot
extends Node2D

@onready var octopus: Octopus = %Octopus


func _ready() -> void:
	pass

func get_body() -> Octopus:
	var child = get_child(0) as Octopus
	return child

func get_player() -> Octopus:
	return Game.player_one

func _process(delta: float) -> void:
	var player := get_player()
	if not player: return
	octopus.steer_towards(player.global_position)
