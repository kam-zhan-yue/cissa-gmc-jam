class_name PrimaryArm
extends Arm

const MAX_REACH = 200.0
const ARM_SPEED = 600.0

var grab: Item

enum ARM_STATE {
	NONE,
	HOVER,
	GRAB,
}

var state := ARM_STATE.NONE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self._process_grab()
	self._process_aim(delta)
	queue_redraw()

func _process_grab() -> void:
	match self.state:
		ARM_STATE.HOVER:
			pass
		ARM_STATE.GRAB:
			if grab:
				grab.global_position = global_position + _get_hand_position()
		

func _process_aim(delta: float) -> void:
	var aim_vertical := Input.get_axis("player_1_aim_down", "player_1_aim_up")
	var aim_horizontal := Input.get_axis("player_1_aim_left", "player_1_aim_right")
	var target_velocity := Vector2(aim_horizontal, -aim_vertical)
	self.aim += target_velocity * delta * ARM_SPEED
	if self.aim.length() >= MAX_REACH:
		self.aim = self.aim.normalized() * MAX_REACH
	hand.position = _get_hand_position()

func _input(_event: InputEvent) -> void:
	if state == ARM_STATE.HOVER and Input.is_action_just_pressed("player_1_grab") and grab:
		self.state = ARM_STATE.GRAB
		print("GRAB")
	elif state == ARM_STATE.GRAB and Input.is_action_just_released("player_1_grab"):
		print("RELEASE")
		self.grab = null
		self.state = ARM_STATE.NONE


func _on_hand_body_entered(body: Node2D) -> void:
	if body is Item and self.state == ARM_STATE.NONE:
		self.state = ARM_STATE.HOVER
		self.grab = body
		print("HOVER")


func _on_hand_body_exited(body: Node2D) -> void:
	if self.state == ARM_STATE.HOVER:
		self.state = ARM_STATE.NONE
