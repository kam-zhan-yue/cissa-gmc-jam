class_name Octopus
extends CharacterBody2D

@export var player_id := 0
const movement_speed = 300

var state := STATE.FREE

enum STATE {
	FREE,
	KNOCKBACK,
}

func _physics_process(delta: float) -> void:
	if state == STATE.FREE:
		var move_vertical := Input.get_axis("player_" + str(player_id) + "_move_down", "player_" + str(player_id) + "_move_up")
		var move_horizontal := Input.get_axis("player_" + str(player_id) + "_move_left", "player_" + str(player_id) + "_move_right")
		var target_direction := Vector2(move_horizontal, -move_vertical)
		velocity = target_direction * movement_speed

	move_and_slide()

func knockback(force: Vector2, time: float) -> void:
	self.state = STATE.KNOCKBACK
	velocity = force
	await Global.wait(time)
	self.state = STATE.FREE
