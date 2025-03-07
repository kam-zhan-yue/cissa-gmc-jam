extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.on_game_over.connect(on_game_over)
	self.hide() # Replace with function body.


func on_game_over(winner_id: int) -> void:
	get_tree().paused = true
	
	# Update the win message based on which player won
	if winner_id == 1:
		$WinMessage.text = "Player 0 wins!"
	else:
		$WinMessage.text = "Player 1 wins!"
	

	# Show the UI layer	
	self.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Restart button at Game Over Scene
func _on_button_pressed() -> void:
	print("Button pressed!")
	
	# Resets the scene and start new game
	get_tree().paused = false
	get_tree().reload_current_scene()


	# restarts the game 
