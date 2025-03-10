class_name Blade
extends Area2D

const GAME_SETTINGS = preload("res://resources/game_settings.tres")

var id := -1
const COOLDOWN_TIME = 0.5
var cooldown := false
var active := false
var prev_pos := Vector2.ZERO
var velocity := Vector2.ZERO

@onready var sword: Item = $".."

func _ready() -> void:
	sword.on_grab.connect(_on_grab)
	sword.on_release.connect(_on_release)

func _on_grab(holder_id: int) -> void:
	self.active = true
	self.id = holder_id

func _on_release(_holder_id: int) -> void:
	self.active = false
	self.id = -1

func _physics_process(_delta: float) -> void:
	velocity = global_position - prev_pos
	prev_pos = global_position

func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if not active: return
	if cooldown: return
	if body is not Octopus: return
	if body.player_id == self.id: return
	var collision_direction = velocity
	if collision_direction:
		var force = collision_direction.normalized() * GAME_SETTINGS.hit_force
		var clang_sound = $"../Clang Sound"
		if clang_sound:
			clang_sound.play()
		body.knockback(force, GAME_SETTINGS.knockback_time)
		_start_cooldown()

func _start_cooldown() -> void:
	cooldown = true
	Global.wait(COOLDOWN_TIME)
	cooldown = false
