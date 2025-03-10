class_name CustomButton
extends Control

var mouse_entered := false
var mouse_pressed := false

func _ready():
	set_process_input(true)

func _input(event):	
	if event is InputEventMouseButton:
		if event.is_pressed():
			mouse_pressed = true
		else:
			mouse_pressed = false

func _on_mouse_entered():
	mouse_entered = true


func _on_mouse_exited() -> void:
	mouse_entered = false
