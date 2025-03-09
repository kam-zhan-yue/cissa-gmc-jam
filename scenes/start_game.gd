extends Control


# When Start Button is clicked
func _on_button_pressed() -> void:
	pass # Replace with function body.
	print('start button got pressed')
	
	# Hide the screen
	Global.set_inactive(self)
