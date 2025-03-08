class_name PrimaryArm
extends Arm
@export var player_id := 0
const MAX_REACH = 100.0
const ARM_SPEED = 100.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var aim_vertical := Input.get_axis("player_" + str(player_id) + "_aim_down", "player_" + str(player_id) + "_aim_up")
	var aim_horizontal := Input.get_axis("player_" + str(player_id) + "_aim_left", "player_" + str(player_id) + "_aim_right")
	var target_velocity := Vector2(aim_horizontal, -aim_vertical)
	self.aim += target_velocity * delta * ARM_SPEED

	queue_redraw()
