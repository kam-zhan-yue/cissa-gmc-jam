class_name GameOverPopup
extends Control

@onready var win_text := $WinText as RichTextLabel

func _ready() -> void:
	Global.set_inactive(self)
	
# Called when the node enters the scene tree for the first time.
func init() -> void:
	Game.on_game_over.connect(on_game_over)

func on_game_over(winner_id: int) -> void:
	if winner_id == 0:
		win_text.text = "Player 1 wins!"
	else:
		win_text.text = "Player 2 wins!"

	Global.set_active(self)
