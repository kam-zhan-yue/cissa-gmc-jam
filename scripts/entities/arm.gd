class_name Arm
extends Node2D

var aim := Vector2.ZERO

@onready var hand: Area2D = %Hand

var constraints: Array[Constraint] = []

func _ready() -> void:
	for i in 10:
		constraints.append(Constraint.new(Vector2.ZERO, 10.0))

func _get_hand_position() -> Vector2:
	return position + self.aim

func _draw():
	for i in range(len(constraints)):
		_draw_constraint(i)
		

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
			
			
		
