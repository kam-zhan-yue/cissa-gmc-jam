class_name PrimaryArm
extends Arm

@export var use_mouse := false
@onready var hand: Area2D = %Hand

var id := 0

const ARM_SPEED = 2000.0
const THROW_VELOCITY = 1000.0

var arm_velocity := Vector2.ZERO
var target_position := Vector2.ZERO
var grab: Item

enum GRAB_STATE {
	NONE,
	HOVER,
	GRAB,
}

var state := GRAB_STATE.NONE

func init(player_id: int) -> void:
	self.arm_state = ARM_STATE.AIMING
	self.id = player_id

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	self._process_grab()
	self._process_aim(delta)
	self._process_movement(delta)
	self._process_input()

func _process_grab() -> void:
	match self.state:
		GRAB_STATE.HOVER:
			pass
		GRAB_STATE.GRAB:
			if grab:
				var direction = self.aim - position
				var angle = atan2(direction.y, direction.x)
				grab.rotation = angle + PI * 0.5
				grab.global_position = _get_hand_position()
		

func _process_aim(_delta: float) -> void:
	var aim_vertical := Input.get_axis(Global.get_input(id, "aim_down"), Global.get_input(id, "aim_up"))
	var aim_horizontal := Input.get_axis(Global.get_input(id, "aim_left"), Global.get_input(id, "aim_right"))
	var target := Vector2(aim_horizontal, -aim_vertical)

	if use_mouse:
		var camera = get_viewport().get_camera_2d()
		var mouse_pos := camera.get_global_mouse_position()
		var distance_to_player = (mouse_pos - position) / Arm.MAX_REACH
		target = distance_to_player


	self.target_position = target * Arm.MAX_REACH
	if self.target_position.length() >= Arm.MAX_REACH:
		self.target_position = self.target_position.normalized() * Arm.MAX_REACH
	
func _process_movement(delta: float) -> void:
	var previous := self.aim
	self.aim = self.aim.move_toward(self.target_position, delta * ARM_SPEED)
	self.arm_velocity = self.aim - previous
	hand.global_position = _get_hand_position()

func _process_input() -> void:
	if Input.is_action_just_pressed(Global.get_input(id, "grab")):
		# Grab if we are hovering
		print("WHAT")
		if state == GRAB_STATE.HOVER and grab:
			self._grab()
		elif state == GRAB_STATE.GRAB:
			self._throw()

func _throw_item() -> void:
	if not grab: return
	if grab.throwable:
		var throw_velocity = self.arm_velocity.normalized() * THROW_VELOCITY
		grab.launch(throw_velocity)
	

func _input(event: InputEvent) -> void:
	if use_mouse and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				self._grab()
			else:
				self._throw()

func _grab() -> void:
	print("GRAB ", self.id)
	if grab:
		grab.grab(self)
	self.state = GRAB_STATE.GRAB

func _throw() -> void:
	_release()
	_throw_item()

func _release() -> void:
	if grab:
		grab.release(self)
	self.grab = null
	self.state = GRAB_STATE.NONE
	print("RELEASE")

func _on_hand_body_entered(body: Node2D) -> void:
	if body is Item and self.state == GRAB_STATE.NONE:
		self.state = GRAB_STATE.HOVER
		self.grab = body
		self._grab()


func _on_hand_body_exited(body: Node2D) -> void:
	if self.state == GRAB_STATE.HOVER:
		self.state = GRAB_STATE.NONE
