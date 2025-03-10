class_name Item
extends CharacterBody2D

const GAME_SETTINGS = preload("res://resources/game_settings.tres")

@export var throwable := false
@export var collision_force := 5.0
@export var knockback_time := 0.5

const DECELERATION_SPEED := 200.0

const BOUNCE_FADE = 0.2

var original_layer
var original_mask
var can_grab := true
var deceleration := 00

var holder: PrimaryArm = null
var state := STATE.IDLE
var original_pos := Vector2.ZERO
var original_rotation := 0.0
var in_killzone := false

signal on_grab(id)
signal on_release(id)

enum STATE {
	IDLE,
	LAUNCHING,
}

func _ready() -> void:
	self.original_pos = global_position
	self.original_rotation = rotation
	self.original_layer = self.collision_layer
	self.original_mask = self.collision_mask

func init(id: int) -> void:
	self.holder_id = id
	
func grab(new_holder: PrimaryArm) -> void:
	# If we have a holder, we want the holder to force release
	if holder:
		holder._release()
	holder = new_holder
	on_grab.emit(holder.id)
	self.collision_layer = Global.GRAB_LAYER
	self.collision_mask = Global.GRAB_LAYER

func release(old_holder: PrimaryArm) -> void:
	on_release.emit(old_holder.id)
	holder = null
	if STATE.IDLE:
		self.collision_layer = self.original_layer
		self.collision_mask = self.original_mask

func _physics_process(delta: float) -> void:
	if not throwable: return
	velocity -= velocity.normalized() * deceleration * delta
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		velocity *= BOUNCE_FADE
		deceleration = DECELERATION_SPEED
		#var collider = collision.get_collider()
		#if collider is Octopus:
			#var direction = collider.global_position - global_position
			#collider.knockback(direction * collision_force, knockback_time)

func launch(launch_velocity: Vector2) -> void:
	self.deceleration = 0.0
	self.velocity = launch_velocity
	#self.can_grab = false
	#self.collision_layer = 100
	#self.collision_mask = 100
	#self.state = STATE.LAUNCHING
	#await Global.wait(0.1)
	self.can_grab = true
	self.collision_layer = self.original_layer
	self.collision_mask = self.original_mask
	self.state = STATE.IDLE

func respawn() -> void:
	if not in_killzone:
		return
	velocity = Vector2.ZERO
	global_position = self.original_pos
	rotation = self.rotation

func enter_killzone() -> void:
	in_killzone = true
	await get_tree().create_timer(GAME_SETTINGS.despawn_time).timeout
	check_killzone()

func check_killzone() -> void:
	if holder:
		enter_killzone()
	else:
		respawn()

func exit_killzone() -> void:
	in_killzone = false
