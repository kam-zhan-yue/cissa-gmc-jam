class_name Item
extends CharacterBody2D

func _physics_process(delta: float) -> void:
	move_and_slide()

func launch(launch_velocity: Vector2) -> void:
	self.velocity = launch_velocity
	print("Launch ", launch_velocity)
