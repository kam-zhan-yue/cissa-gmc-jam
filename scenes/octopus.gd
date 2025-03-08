class_name Octopus
extends CharacterBody2D

@export var player_id := 0
@export var max_lives : int = 3
var lives : int
const movement_speed = 300
@onready var primary_arm: PrimaryArm = %PrimaryArm

var state := STATE.FREE

enum STATE {
	FREE,
	KNOCKBACK,
}

func _ready() -> void:
	primary_arm.init(player_id)


func _physics_process(delta: float) -> void:
	if state == STATE.FREE:
		var move_vertical := Input.get_axis(Global.get_input(player_id, "move_down"), Global.get_input(player_id, "move_up"))
		var move_horizontal := Input.get_axis(Global.get_input(player_id, "move_left"), Global.get_input(player_id, "move_right"))
		var target_direction := Vector2(move_horizontal, -move_vertical)
		velocity = target_direction * movement_speed

	move_and_slide()

func knockback(force: Vector2, time: float) -> void:
	self.state = STATE.KNOCKBACK
	velocity = force
	await Global.wait(time)
	self.state = STATE.FREE
