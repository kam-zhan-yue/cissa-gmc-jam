class_name Octopus
extends CharacterBody2D

const ARM = preload("res://scenes/arm.tscn")
const GAME_SETTINGS = preload("res://resources/game_settings.tres")
const OCTOHEAD_1 = preload("res://assets/octohead1.png")
const OCTOHEAD_2 = preload("res://assets/octohead2.png")

@onready var head: Sprite2D = %Head
@export var debug := false
@export var player_id := -1
@export var num_arms:= 7
@export var max_lives : int = 3
@onready var primary_arm: PrimaryArm = %PrimaryArm
@onready var arms := %Arms as Arms
var lives : int
var ink := GAME_SETTINGS.max_ink

var facing_direction = Vector2.ZERO

var state := STATE.FREE
var external := Vector2.ZERO

signal on_ink_changed(ink: float)
signal on_respawn

enum STATE {
	DEACTIVATED,
	FREE,
	KNOCKBACK,
	DASH,
	BURST,
}

func _ready() -> void:
	if debug:
		init()

func init() -> void:
	if player_id == Game.PLAYER_ONE:
		head.texture = OCTOHEAD_1
		name = "Player One"
	else:
		head.texture = OCTOHEAD_2
		name = "Player Two"
	primary_arm.init(player_id)
	for i in range(num_arms):
		var arm = ARM.instantiate()
		arms.add_child(arm)
	arms.init(player_id)

func steer_towards(target: Vector2) -> void:
	var direction = target - global_position
	external = direction.normalized()
	
	
	
func steer_away(target: Vector2) -> void:
	var direction = global_position - target
	external = direction.normalized()
	


func is_holding_item() -> bool:
	return primary_arm.grab != null

func grab_towards(target: Vector2) -> void:
	primary_arm.grab_towards(target)

func _physics_process(delta: float) -> void:
	if state == STATE.DEACTIVATED:
		return

	if state == STATE.FREE:
		var target_direction := get_input() + external
		$"ink burst".emitting = false
		$inktrail.emitting = false
		if target_direction and Input.is_action_just_pressed(Global.get_input(player_id, "dash")) and ink >= GAME_SETTINGS.burst_cost:
			ink -= GAME_SETTINGS.burst_cost
			on_ink_changed.emit(ink)
			burst(GAME_SETTINGS.burst_speed * target_direction, GAME_SETTINGS.burst_time)

		else:
			velocity = target_direction * GAME_SETTINGS.movement_speed
			if ink < GAME_SETTINGS.max_ink:
				ink += GAME_SETTINGS.ink_regen_rate * delta
				on_ink_changed.emit(ink)
			elif ink >= GAME_SETTINGS.max_ink:
				ink = GAME_SETTINGS.max_ink
				on_ink_changed.emit(ink)
			
	elif state == STATE.DASH:
		var target_direction := get_input()
		if Input.is_action_pressed(Global.get_input(player_id, "dash")) and ink >= 0:
			ink -= delta * GAME_SETTINGS.dash_cost_rate
			on_ink_changed.emit(ink)
			velocity = GAME_SETTINGS.dash_speed * target_direction
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

func deactivate() -> void:
	self.state = STATE.DEACTIVATED
	# Trigger a despawn for the item
	if primary_arm.grab:
		primary_arm.grab.enter_killzone()
	primary_arm._release()
	Global.set_inactive(self)

func respawn(pos: Vector2) -> void:
	self.state = STATE.FREE
	Global.set_active(self)
	on_respawn.emit()
	global_position = pos
