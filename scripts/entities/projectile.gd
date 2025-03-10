class_name Projectile
extends Area2D

const GAME_SETTINGS = preload("res://resources/game_settings.tres")

const COOLDOWN_TIME = 0.5
var cooldown := false

@onready var item: Item = $".."


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if item.state == Item.STATE.LAUNCHING:
		print("Don't hit while launching")
		return
	if cooldown: return
	if body is not Octopus: return
	var body_octopus := body as Octopus
	if item.holder and item.holder.id == body_octopus.player_id:
		print("Don't hit player")
		return
	print("Projectile Collided")
	var collision_direction = Global.get_collision_direction(body_rid, body, body_shape_index, local_shape_index, self)
	if collision_direction:
		var force = collision_direction.normalized() * GAME_SETTINGS.hit_force
		body.knockback(force, 1.0)
		_start_cooldown()

func _start_cooldown() -> void:
	cooldown = true
	Global.wait(COOLDOWN_TIME)
	cooldown = false
	
