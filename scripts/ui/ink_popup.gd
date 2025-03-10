class_name InkPopup
extends Control

const GAME_SETTINGS = preload("res://resources/game_settings.tres")
@onready var ink_container: MarginContainer = %InkContainer

var player_id := 0
var max_ink := 0.0

func init(id: int) -> void:
	self.player_id = id
	Game.get_player(id).on_ink_changed.connect(_on_ink_changed)
	_on_ink_changed(Game.get_player(id).ink)

func _on_ink_changed(ink: float) -> void:
	ink_container.scale.x = ink / GAME_SETTINGS.max_ink
