class_name Arms
extends Node2D

@onready var octopus: Octopus = $".."

var arms: Array[Arm] = []
var primary_arm: PrimaryArm
var restriction = 0.0

const RESTRICTION_ANGLE = -50.0
const STRIDE_DISTANCE = 150.0
const ARM_SPEED = 900.0


func init() -> void:
	var restriction = RESTRICTION_ANGLE
	var children = get_children()
	for child in children:
		if child is Arm and child is not PrimaryArm:
			arms.append(child as Arm)
		if child is PrimaryArm:
			primary_arm = child
	var positions = get_positions()
	for i in range(len(positions)):
		arms[i].target = positions[i]
		arms[i].arm_state = Arm.ARM_STATE.SEARCHING
	

func _process(delta: float) -> void:
	#var direction = 
	if octopus.state == Octopus.STATE.DASH or octopus.state == Octopus.STATE.BURST:
		restriction = 250.0
		for arm in arms:
			arm.set_speed(2000.0)
		primary_arm.set_speed(2000.0)
	else:
		restriction = RESTRICTION_ANGLE
		for arm in arms:
			arm.reset_speed()
		primary_arm.reset_speed()
	var positions = get_positions()
	for i in range(len(positions)):
		arms[i].target = positions[i]
	queue_redraw()

func get_positions() -> Array[Vector2]:
	var space_state = get_world_2d().direct_space_state
	var positions: Array[Vector2] = []
	var target_direction = octopus.get_direction()
	var player_angle := atan2(-target_direction.y, target_direction.x)

	var start_angle := deg_to_rad(restriction) * 0.5
	var end_angle := 2 * PI - deg_to_rad(restriction) * 0.5
	var angle_distance := (end_angle - start_angle) / (len(arms) + 1)
	
	
	for i in range(len(arms)):
		var angle := player_angle + start_angle + angle_distance * (i + 1)
		var x := Arm.MAX_REACH * cos(angle)
		var y := Arm.MAX_REACH * sin(angle)
		var target_pos = global_position + Vector2(x, -y)
		
		# Look for an obstacle, if there is an obstacle, set the position to the result
		var query = PhysicsRayQueryParameters2D.create(global_position, target_pos, Game.OBSTACLE_COLLISION_MASK)
		var result = space_state.intersect_ray(query)
		if result:
			target_pos = result['position']
		
		var difference = target_pos - arms[i].target
		if difference.length() >= STRIDE_DISTANCE:
			positions.append(target_pos)
		else:
			positions.append(arms[i].target)
	return positions


func _draw() -> void:
	var positions = get_positions()

	for i in range(len(positions)):
		if i == 0:
			draw_circle(positions[i] - global_position, 10, Color.WHITE)
		else:
			draw_circle(positions[i] - global_position, 10, Color.BLACK)
