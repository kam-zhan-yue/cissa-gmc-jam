class_name Blade
extends Area2D

var id := -1
const FORCE = 1000.0
const COOLDOWN_TIME = 0.5
var cooldown := false
var active := false

@onready var sword: Item = $".."

func _ready() -> void:
	sword.on_grab.connect(_on_grab)
	sword.on_release.connect(_on_release)

func _on_grab(holder_id: int) -> void:
	self.active = true
	self.id = holder_id

func _on_release(holder_id: int) -> void:
	self.active = false
	self.id = -1

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if not active: return
	if cooldown: return
	if body is not Octopus: return
	if body.player_id == self.id: return
	var collision_direction = Global.get_collision_direction(body_rid, body, body_shape_index, local_shape_index, self)
	if collision_direction:
		var force = collision_direction.normalized() * FORCE
		body.knockback(force, 1.0)
		_start_cooldown()

func _start_cooldown() -> void:
	cooldown = true
	Global.wait(COOLDOWN_TIME)
	cooldown = false
	
