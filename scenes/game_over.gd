class_name GameOverPopup
extends Control


func _ready() -> void:
	Global.set_inactive(self)
	
# Called when the node enters the scene tree for the first time.
func init() -> void:
	Game.on_game_over.connect(on_game_over)


func on_game_over(winner_id: int) -> void:
	get_tree().paused = true
	
	# Update the win message based on which player won
	if winner_id == 1:
		$WinMessage.text = "Player 0 wins!"
	else:
		$WinMessage.text = "Player 1 wins!"
	

	Global.set_active(self)


# Restart button at Game Over Scene
func _on_button_pressed() -> void:
	print("Button pressed!")
	
	# Resets the scene and start new game
	get_tree().paused = false
	get_tree().reload_current_scene()


	# restarts the game 
