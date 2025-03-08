class_name Arm
extends Node2D

var aim := Vector2.ZERO

@onready var hand: Area2D = %Hand

var constraints: Array[Constraint] = []

func _ready() -> void:
	for i in 10:
		constraints.append(Constraint.new(Vector2.ZERO, 10.0, 0.0))

func _get_hand_position() -> Vector2:
	return position + self.aim

func _draw():
	_draw_fabrik()

func _draw_constraint(i: int) -> void:
	var node_distance = PrimaryArm.MAX_REACH / len(constraints)
	var godot_blue : Color = Color("478cbf")
	if i == 0:
		constraints[i].position = _get_hand_position()
		draw_circle(_get_hand_position(), constraints[i].radius, godot_blue)
	else:
		var prev = constraints[i-1]
		var curr = constraints[i]
		var difference = curr.position - prev.position
		# If the constraint is past the distance per node, we wanna lock it
		if difference.length() >= node_distance:
			var new_position = prev.position + difference.normalized() * node_distance
			constraints[i].position = new_position
			draw_circle(new_position, constraints[i].radius, godot_blue)
		else:
			draw_circle(curr.position, constraints[i].radius, godot_blue)
			
func _draw_fabrik() -> void:
	_draw_backwards()
	_draw_forwards()

func _draw_backwards() -> void:
	var godot_blue : Color = Color("478cbf")
	var node_distance := PrimaryArm.MAX_REACH / len(constraints)
	# Set the end constraint to the end effector
	var target_pos = _get_hand_position()
	constraints[-1].position = target_pos
	draw_circle(constraints[-1].position, constraints[-1].radius, godot_blue)
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

func _draw_forwards() -> void:
	var godot_blue : Color = Color("478cbf")
	var node_distance := PrimaryArm.MAX_REACH / len(constraints)
	# Set the start constraint to the origin
	constraints[0].position = position
	draw_circle(constraints[0].position, constraints[0].radius, godot_blue)
	for i in range(len(constraints) - 1):
		var next_node := constraints[i + 1].position
		var curr_node := constraints[i].position
		var difference := next_node - curr_node
		
		if difference.length() >= node_distance:
			var new_position := curr_node + difference.normalized() * node_distance
			constraints[i + 1].position = new_position
			draw_circle(new_position, constraints[i + 1].radius, godot_blue)
		else:
			draw_circle(next_node, constraints[i + 1].radius, godot_blue)
