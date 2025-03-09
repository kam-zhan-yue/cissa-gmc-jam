class_name PrimaryArm
extends Arm

@export var use_mouse := false
@onready var hand: Area2D = %Hand

var id := 0

var target_position := Vector2.ZERO
var grab: Item

var prev_aim := Vector2.ZERO
var curr_aim := Vector2.ZERO

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
	self.redraw(delta)

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
	prev_aim = curr_aim
	var aim_vertical := Input.get_axis(Global.get_input(id, "aim_down"), Global.get_input(id, "aim_up"))
	var aim_horizontal := Input.get_axis(Global.get_input(id, "aim_left"), Global.get_input(id, "aim_right"))
	var target_pos := Vector2(aim_horizontal, -aim_vertical)
	curr_aim = target_pos

	if use_mouse:
		var camera = get_viewport().get_camera_2d()
		var mouse_pos := camera.get_global_mouse_position()
		var distance_to_player = (mouse_pos - position) / GAME_SETTINGS.max_reach
		target_pos = distance_to_player


	self.target_position = target_pos * GAME_SETTINGS.max_reach
	if self.target_position.length() >= GAME_SETTINGS.max_reach:
		self.target_position = self.target_position.normalized() * GAME_SETTINGS.max_reach
	
func _process_movement(delta: float) -> void:
	if not curr_aim:
		self._pull_back()
	else:
		self.arm_state = ARM_STATE.AIMING
		var next_hand_position = _get_next_hand_position(delta)
		self.aim = next_hand_position
	hand.global_position = _get_hand_position()

func _get_next_hand_position(delta: float) -> Vector2:
	var next_hand_position = self.aim.move_toward(self.target_position, delta * GAME_SETTINGS.primary_tentacle_speed)
	return next_hand_position


func _process_input() -> void:
	if Input.is_action_just_pressed(Global.get_input(id, "grab")) and state == GRAB_STATE.GRAB:
		self._release()

	if _get_aim().length() >= GAME_SETTINGS.throw_threshold and state == GRAB_STATE.GRAB:
		self._throw()

func _get_aim() -> Vector2:
	return curr_aim - prev_aim

func _throw_item() -> void:
	if not grab: return
	if grab.throwable:
		var throw_velocity = _get_aim().normalized() * GAME_SETTINGS.throw_force
		grab.launch(throw_velocity)
	

func _grab() -> void:
	if grab:
		grab.grab(self)
	self.state = GRAB_STATE.GRAB

func _throw() -> void:
	if grab and grab.throwable:
		_throw_item()
		_release()

func _release() -> void:
	if grab:
		grab.release(self)
	self.grab = null
	self.state = GRAB_STATE.NONE

func _on_hand_body_entered(body: Node2D) -> void:
	# Do not grab if we don't have an input
	if not curr_aim:
		return
	if body is Item and self.state == GRAB_STATE.NONE and body.can_grab:
		self.state = GRAB_STATE.HOVER
		self.grab = body
		self._grab()


func _on_hand_body_exited(_body: Node2D) -> void:
	if self.state == GRAB_STATE.HOVER:
		self.state = GRAB_STATE.NONE
