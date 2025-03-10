class_name Arms
extends Node2D

const GAME_SETTINGS = preload("res://resources/game_settings.tres")
@onready var octopus: Octopus = $"../.."

@onready var primary_arm := %PrimaryArm as PrimaryArm
var arms: Array[Arm] = []
var restriction = 0.0


func init(player_id: int) -> void:
	var restriction = GAME_SETTINGS.restriction_angle
	var children = get_children()
	for child in children:
		if child is Arm and child is not PrimaryArm:
			var child_arm = child as Arm
			arms.append(child_arm)
			child_arm.init_arm(player_id)
	var positions = get_positions()
	for i in range(len(positions)):
		arms[i].target = positions[i]
		arms[i].arm_state = Arm.ARM_STATE.SEARCHING
	

func _process(_delta: float) -> void:
	#var direction = 
	if octopus.state == Octopus.STATE.DASH or octopus.state == Octopus.STATE.BURST:
		restriction = 250.0
		for arm in arms:
			arm.set_speed(2000.0)
		primary_arm.set_speed(2000.0)
	else:
		restriction = GAME_SETTINGS.restriction_angle
		for arm in arms:
			arm.reset_speed()
		primary_arm.reset_speed()
	var positions = get_positions()
	for i in range(len(positions)):
		arms[i].target = positions[i]
	if octopus.debug:
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
		var x := GAME_SETTINGS.max_reach * cos(angle)
		var y := GAME_SETTINGS.max_reach * sin(angle)
		var target_pos = global_position + Vector2(x, -y)
		
		# Look for an obstacle, if there is an obstacle, set the position to the result
		var query = PhysicsRayQueryParameters2D.create(global_position, target_pos, Game.OBSTACLE_COLLISION_MASK)
		var result = space_state.intersect_ray(query)
		if result:
			target_pos = result['position']
		
		var difference = target_pos - arms[i].target
		if difference.length() >= GAME_SETTINGS.stride_distance:
			positions.append(target_pos)
		else:
			positions.append(arms[i].target)
	return positions


func _draw() -> void:
	if not octopus.debug:
		return
	var positions = get_positions()

	for i in range(len(positions)):
		if i == 0:
			draw_circle(positions[i] - global_position, 10, Color.WHITE)
		else:
			draw_circle(positions[i] - global_position, 10, Color.BLACK)
