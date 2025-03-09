class_name InkPopup
extends Control

var player_id := 0

func init(id: int) -> void:
	self.player_id = id
	Game.get_player(id).on_ink_changed.connect(_on_ink_changed)
	_on_ink_changed(Game.get_player(id).ink)

func _on_ink_changed(ink: float) -> void:
	pass
