class_name Arm
extends Node2D

var aim := Vector2.ZERO
var target := Vector2.ZERO
const MAX_REACH = 200.0
const DEFAULT_SPEED = 700.0

var constraints: Array[Constraint] = []

var arm_state := ARM_STATE.IDLE

const TOTAL_NODES = 20
const HAND_NODE = 7
const GAME_SETTINGS = preload("res://resources/game_settings.tres")
var arm_speed := 0.0

enum ARM_STATE {
	IDLE,
	SEARCHING,
	AIMING,
}

func _ready() -> void:
	self.arm_speed = DEFAULT_SPEED
	var radius_curve := GAME_SETTINGS.tentacle_radius_curve
	var angle_curve := GAME_SETTINGS.tentacle_angle_curve
	var max_radius := GAME_SETTINGS.tentacle_radius
	var max_angle := PI * 2.0
	for i in TOTAL_NODES:
		var percentage := float(i + 1) / TOTAL_NODES
		var radius_factor = radius_curve.sample(percentage)
		var angle_factor = angle_curve.sample(percentage)
		var radius = max_radius * radius_factor
		var angle = max_angle * angle_factor
		constraints.append(Constraint.new(Vector2.ZERO, radius, angle))

func _get_hand_position() -> Vector2:
	return _get_body_position() + self.aim

func _get_body_position() -> Vector2:
	return global_position

func _process(delta: float) -> void:
	# If we are searching, then we want to update our aim to the target
	if arm_state == ARM_STATE.SEARCHING and target:
		self.aim = self.aim.move_toward(target, delta * arm_speed)
	queue_redraw()

func set_speed(new_speed: float) -> void:
	arm_speed = new_speed

func reset_speed() -> void:
	arm_speed = DEFAULT_SPEED

func _draw():
	match arm_state:
		ARM_STATE.IDLE:
			_draw_forwards()
		ARM_STATE.SEARCHING:
			# If we are searching, we want to go towards the aim
			_draw_fabrik(self.aim, HAND_NODE)
		ARM_STATE.AIMING:
			# If we are moving around, we go towards the hand
			_draw_fabrik(_get_hand_position(), 1)

func _draw_forwards() -> void:
	_process_forwards()
	_draw_constraints()
	
func _draw_fabrik(end_point: Vector2, end_node: int) -> void:
	_process_backwards(end_point, end_node)
	_process_forwards()
	_draw_constraints()

func _process_backwards(end_point: Vector2, end_node: int) -> void:
	var node_distance := Arm.MAX_REACH / len(constraints)
	# Set the end constraint to the end effector
	var target_pos = end_point
	constraints[-end_node].position = target_pos
	# We want to update all the constraint positions up to the first constraint
	# We don't want to set the angle and direction of the first constraint
	for i in range(len(constraints) - end_node, 0, -1):
		var next_node := constraints[i - 1].position
		var curr_node := constraints[i].position
		var difference := next_node - curr_node

		# If the constraint is past the distance per node, we wanna lock it
		if difference.length() >= node_distance:
			var new_position := curr_node + difference.normalized() * node_distance
			constraints[i - 1].position = new_position

func _process_forwards() -> void:
	var node_distance := Arm.MAX_REACH / len(constraints)
	# Set the start constraint to the origin
	constraints[0].position = _get_body_position()
	for i in range(len(constraints) - 1):
		var next_node := constraints[i + 1].position
		var curr_node := constraints[i].position
		var difference := next_node - curr_node
		
		# If the constraint is past the distance per node, we wanna lock it
		if difference.length() >= node_distance:
			var new_position := curr_node + difference.normalized() * node_distance
			constraints[i + 1].position = new_position

func _draw_constraints() -> void:
	for i in range(len(constraints)):
		_draw_constraint(constraints[i])

func _draw_constraint(constraint: Constraint) -> void:
	var godot_blue : Color = Color("478cbf")
	var draw_pos = constraint.position - global_position
	draw_circle(draw_pos, constraint.radius, godot_blue)
