class_name PrimaryArm
extends Arm

@export var use_mouse := false

const MAX_REACH = 200.0
const ARM_SPEED = 2000.0
const THROW_VELOCITY = 1000.0

var arm_velocity := Vector2.ZERO
var target_position := Vector2.ZERO
var grab: Item

enum ARM_STATE {
	NONE,
	HOVER,
	GRAB,
}

var state := ARM_STATE.NONE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	self._process_grab()
	self._process_aim(delta)
	self._process_movement(delta)
	queue_redraw()

func _process_grab() -> void:
	match self.state:
		ARM_STATE.HOVER:
			pass
		ARM_STATE.GRAB:
			if grab:
				grab.global_position = global_position + _get_hand_position()
		

func _process_aim(_delta: float) -> void:
	var aim_vertical := Input.get_axis("player_1_aim_down", "player_1_aim_up")
	var aim_horizontal := Input.get_axis("player_1_aim_left", "player_1_aim_right")
	var target := Vector2(aim_horizontal, -aim_vertical)
	
	if use_mouse:
		var camera = get_viewport().get_camera_2d()
		var mouse_pos := camera.get_global_mouse_position()
		var distance_to_player = (mouse_pos - position) / MAX_REACH
		target = distance_to_player

	
	self.target_position = target * MAX_REACH
	if self.target_position.length() >= MAX_REACH:
		self.target_position = self.target_position.normalized() * MAX_REACH
	
func _process_movement(delta: float) -> void:
	var previous := self.aim
	self.aim = self.aim.move_toward(self.target_position, delta * ARM_SPEED)
	self.arm_velocity = self.aim - previous
	hand.position = _get_hand_position()


func _throw_item() -> void:
	if not grab: return
	var throw_velocity = self.arm_velocity.normalized() * THROW_VELOCITY
	grab.launch(throw_velocity)
	

func _input(event: InputEvent) -> void:
	if state == ARM_STATE.HOVER and Input.is_action_just_pressed("player_1_grab") and grab:
		self._grab()
	elif state == ARM_STATE.GRAB and Input.is_action_just_released("player_1_grab"):
		self._throw()
	elif use_mouse and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				self._grab()
			else:
				self._throw()

func _grab() -> void:
	self.state = ARM_STATE.GRAB

func _throw() -> void:
	_throw_item()
	self.grab = null
	self.state = ARM_STATE.NONE

func _on_hand_body_entered(body: Node2D) -> void:
	if body is Item and self.state == ARM_STATE.NONE:
		self.state = ARM_STATE.HOVER
		self.grab = body


func _on_hand_body_exited(body: Node2D) -> void:
	if self.state == ARM_STATE.HOVER:
		self.state = ARM_STATE.NONE
