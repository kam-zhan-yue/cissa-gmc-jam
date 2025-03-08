class_name Item
extends CharacterBody2D

@export var throwable := false
@export var collision_force := 5.0
@export var knockback_time := 0.5

const BOUNCE_FADE = 0.8

var original_layer
var original_mask

func _ready() -> void:
	self.original_layer = self.collision_layer
	self.original_mask = self.collision_mask
	
	
func grab() -> void:
	self.collision_layer = Global.GRAB_LAYER
	self.collision_mask = Global.GRAB_LAYER

func release() -> void:
	self.collision_layer = self.original_layer
	self.collision_mask = self.original_mask

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		velocity *= BOUNCE_FADE
		var collider = collision.get_collider()
		if collider is Octopus:
			var direction = collider.global_position - global_position
			collider.knockback(direction * collision_force, knockback_time)

func launch(launch_velocity: Vector2) -> void:
	self.velocity = launch_velocity
	print("Launch ", launch_velocity)
