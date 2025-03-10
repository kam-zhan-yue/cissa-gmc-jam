class_name Projectile
extends Area2D

const GAME_SETTINGS = preload("res://resources/game_settings.tres")

const COOLDOWN_TIME = 0.5
const THRESHOLD := 300.0
var cooldown := false
var velocity := Vector2.ZERO
var prev_pos := Vector2.ZERO

@onready var item: Item = $".."

func _physics_process(_delta: float) -> void:
	velocity = global_position - prev_pos
	prev_pos = global_position

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	pass
	if item.state == Item.STATE.LAUNCHING:
		return
	if cooldown: return
	if body is not Octopus: return
	var body_octopus := body as Octopus
	if item.holder and item.holder.id == body_octopus.player_id:
		return
	# If we are being thrown and we are not fast enough...
	if not item.holder and item.velocity.length() < THRESHOLD:
		return
	
	var collision_direction = velocity
	if collision_direction:
		var force = collision_direction.normalized() * GAME_SETTINGS.hit_force
		body.knockback(force, 1.0)
		_start_cooldown()

func _start_cooldown() -> void:
	cooldown = true
	Global.wait(COOLDOWN_TIME)
	cooldown = false
	
