class_name Octopus
extends CharacterBody2D

@export var player_id := 0
@export var max_lives : int = 3
var lives : int
const movement_speed = 300
@onready var primary_arm: PrimaryArm = %PrimaryArm
@onready var arms := $Arms as Arms
var ink := MAX_INK

const BURST_SPEED = 2000.0 #Instantaneous speed of initial burst
const BURST_TIME = 0.2 #Length of burst
const DASH_SPEED = 700.0 #Extended dash speed
const MAX_INK = 1000000  # Max ink capacity
const REGEN_RATE = 10  # Ink regenerated per second while in FREE state
const DASH_COST_RATE = 20  # Ink cost per dash
const BURST_COST = 40  # Ink cost per burst

var facing_direction = Vector2.ZERO

var state := STATE.FREE

signal on_ink_changed(ink: float)

enum STATE {
	FREE,
	KNOCKBACK,
	DASH,
	BURST,
}

func _ready() -> void:
	primary_arm.init(player_id)
	ink = MAX_INK
	
func _physics_process(delta: float) -> void:
	if state == STATE.FREE:
		var target_direction := get_input()
		$"ink burst".emitting = false
		$inktrail.emitting = false
		if target_direction and Input.is_action_just_pressed(Global.get_input(player_id, "dash")) and ink >= BURST_COST:
			ink -= BURST_COST
			on_ink_changed.emit(ink)
			burst(BURST_SPEED * target_direction, BURST_TIME)

		else:
			velocity = target_direction * movement_speed
			if ink < MAX_INK:
				ink += REGEN_RATE * delta
				on_ink_changed.emit(ink)
			if ink > MAX_INK:
				ink = MAX_INK
				on_ink_changed.emit(ink)
			
	elif state == STATE.DASH:
		var target_direction := get_input()
		if Input.is_action_pressed(Global.get_input(player_id, "dash")) and ink >= 0:
			ink -= delta * DASH_COST_RATE
			on_ink_changed.emit(ink)
			velocity = DASH_SPEED * target_direction
			$"ink burst".emitting = false
			$inktrail.emitting = true
		else:
			state = STATE.FREE
			$inktrail.emitting = false

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
	

func burst(force: Vector2, time: float) -> void:
	self.state = STATE.BURST
	velocity = force
	$splash.play()
	$"ink burst".emitting = true
	$inktrail.emitting = true
	await Global.wait(time)
	self.state = STATE.DASH

func knockback(force: Vector2, time: float) -> void:
	self.state = STATE.KNOCKBACK
	velocity = force
	$clash.play()
	await Global.wait(time)
	self.state = STATE.FREE
