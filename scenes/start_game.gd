extends Control

var showing := true

func _process(_delta: float) -> void:
	if not showing:
		return
	if Input.is_action_just_pressed(Global.get_input(0, 'dash')):
		print('close')
		_on_button_pressed()

# When Start Button is clicked
func _on_button_pressed() -> void:
	pass # Replace with function body.
	print('start button got pressed')
	
	showing = false
	# Hide the screen
	Global.set_inactive(self)
