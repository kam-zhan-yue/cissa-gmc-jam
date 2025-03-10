class_name UI
extends Control
@onready var start_game := %StartGame as StartGamePopup
@onready var game_over := %GameOver as GameOverPopup
@onready var hud := %HUD as HUD


func init() -> void:
	start_game.init()
	game_over.init()
	hud.init()
