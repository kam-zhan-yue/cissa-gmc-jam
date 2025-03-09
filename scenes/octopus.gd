class_name Octopus
extends CharacterBody2D

@export var player_id := 0
@export var max_lives : int = 3
var lives : int
const movement_speed = 300
@onready var primary_arm: PrimaryArm = %PrimaryArm
@onready var arms := $Arms as Arms

const RESTRICTION_ANGLE = 50.0

var facing_direction = Vector2.ZERO

var state := STATE.FREE

enum STATE {
	FREE,
	KNOCKBACK,
}

func _ready() -> void:
	primary_arm.init(player_id)


func _physics_process(delta: float) -> void:
	#global_position = Vector2.ZERO
	if state == STATE.FREE:
		var target_direction := get_input()
		velocity = target_direction * movement_speed

	move_and_slide()
	
func get_input() -> Vector2:
	var move_vertical := Input.get_axis(Global.get_input(player_id, "move_down"), Global.get_input(player_id, "move_up"))
	var move_horizontal := Input.get_axis(Global.get_input(player_id, "move_left"), Global.get_input(player_id, "move_right"))
	var input := Vector2(move_horizontal, -move_vertical)
	return input

func get_direction() -> Vector2:
	var input := get_input()
	if input:
		facing_direction = input
	return facing_direction
	


func knockback(force: Vector2, time: float) -> void:
	self.state = STATE.KNOCKBACK
	velocity = force
	await Global.wait(time)
	self.state = STATE.FREE
