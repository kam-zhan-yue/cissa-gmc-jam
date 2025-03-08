class_name GameManager
extends Node2D

@onready var ui: UI = %UI
@onready var camera := %Camera as DynamicCamera
@onready var player_one := %PlayerOne as Octopus
@onready var player_two := %PlayerTwo as Octopus

func _ready() -> void:
	camera.add_target(player_one)
	camera.add_target(player_two)
	Game.init(player_one, player_two)
