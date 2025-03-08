class_name Projectile
extends Area2D

const FORCE = 1000.0
const COOLDOWN_TIME = 0.5
var cooldown := false

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if cooldown: return
	if body is not Octopus: return
	var collision_direction = Global.get_collision_direction(body_rid, body, body_shape_index, local_shape_index, self)
	if collision_direction:
		var force = collision_direction.normalized() * FORCE
		body.knockback(force, 1.0)
		_start_cooldown()

func _start_cooldown() -> void:
	cooldown = true
	Global.wait(COOLDOWN_TIME)
	cooldown = false
	
