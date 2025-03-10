class_name TutorialPopup
extends Control


var showing := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.on_tutorial.connect(_on_tutorial)
	Global.set_inactive(self)
	showing = false

func _on_tutorial() -> void:
	Global.set_active(self)
	showing = true
