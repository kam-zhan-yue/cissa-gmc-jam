class_name Arm
extends Node2D

var aim := Vector2.ZERO

@onready var hand: Area2D = %Hand

var constraints: Array[Constraint] = []

func _ready() -> void:
	for i in 10:
		constraints.append(Constraint.new(Vector2.ZERO, 10.0, 0.0))

func _get_hand_position() -> Vector2:
	return _get_body_position() + self.aim

func _get_body_position() -> Vector2:
	return global_position

func _draw():
	_draw_fabrik()
			
func _draw_fabrik() -> void:
	_process_backwards()
	_process_forwards()
	_draw_constraints()

func _process_backwards() -> void:
	var node_distance := PrimaryArm.MAX_REACH / len(constraints)
	# Set the end constraint to the end effector
	var target_pos = _get_hand_position()
	constraints[-1].position = target_pos
	# We want to update all the constraint positions up to the first constraint
	# We don't want to set the angle and direction of the first constraint
	for i in range(len(constraints) - 1, 0, -1):
		var next_node := constraints[i - 1].position
		var curr_node := constraints[i].position
		var difference := next_node - curr_node

		# If the constraint is past the distance per node, we wanna lock it
		if difference.length() >= node_distance:
			var new_position := curr_node + difference.normalized() * node_distance
			constraints[i - 1].position = new_position

func _process_forwards() -> void:
	var node_distance := PrimaryArm.MAX_REACH / len(constraints)
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
