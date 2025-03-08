extends Area2D

func _on_body_exited(body: Node2D):
	print("game!")
	get_tree().reload_current_scene()
