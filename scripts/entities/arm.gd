class_name Arm
extends Node2D

var aim := Vector2.ZERO
var target := Vector2.ZERO
var id := -1

var constraints: Array[Constraint] = []

var arm_state := ARM_STATE.IDLE

const GAME_SETTINGS = preload("res://resources/game_settings.tres")
var arm_speed := 0.0
var fill_colour := Color.WHITE
var border_colour := Color.BLACK

const PULL_BACK_THRESHOLD = 8.0

enum ARM_STATE {
	IDLE,
	SEARCHING,
	AIMING,
	PULLING_BACK,
}

func init_arm(player_id: int) -> void:
	id = player_id
	if player_id == 0:
		fill_colour = GAME_SETTINGS.player_one_fill_colour
		border_colour = GAME_SETTINGS.player_one_border_colour
	else:
		fill_colour = GAME_SETTINGS.player_two_fill_colour
		border_colour = GAME_SETTINGS.player_two_border_colour

	self.arm_speed = GAME_SETTINGS.tentacle_speed
	var radius_curve := GAME_SETTINGS.tentacle_radius_curve
	var angle_curve := GAME_SETTINGS.tentacle_angle_curve
	var max_radius := GAME_SETTINGS.tentacle_radius
	var max_angle := PI * 2.0
	for i in GAME_SETTINGS.total_nodes:
		var percentage := float(i + 1) / GAME_SETTINGS.total_nodes
		var radius_factor = radius_curve.sample(percentage)
		var angle_factor = angle_curve.sample(percentage)
		var radius = max_radius * radius_factor
		var angle = max_angle * angle_factor
		constraints.append(Constraint.new(Vector2.ZERO, radius, angle))

func _get_hand_position() -> Vector2:
	return constraints[-1].position

func _get_end_position() -> Vector2:
	return _get_body_position() + self.aim

func _get_body_position() -> Vector2:
	return global_position

func _physics_process(delta: float) -> void:
	redraw(delta)

func _pull_back_physics(delta: float) -> void:
	for i in range(1, len(constraints)):
		var prev := constraints[i - 1].position
		var curr := constraints[i].position
		var difference := curr - prev
		var length := difference.length()
		if length < PULL_BACK_THRESHOLD:
			continue
		length -= delta * arm_speed
		var new_diff := Vector2.from_angle(difference.angle()) * length
		var new_pos := prev + new_diff
		constraints[i].position = new_pos

func redraw(delta: float) -> void:
	# If we are searching, then we want to update our aim to the target
	if arm_state == ARM_STATE.SEARCHING and target:
		self.aim = self.aim.move_toward(target, delta * arm_speed)
	elif arm_state == ARM_STATE.PULLING_BACK:
		_pull_back_physics(delta)
	queue_redraw()

func set_speed(new_speed: float) -> void:
	arm_speed = new_speed

func reset_speed() -> void:
	arm_speed = GAME_SETTINGS.tentacle_speed

func _pull_back() -> void:
	arm_state = ARM_STATE.PULLING_BACK

func _draw():
	match arm_state:
		ARM_STATE.IDLE:
			_draw_forwards()
		ARM_STATE.SEARCHING:
			# If we are searching, we want to go towards the aim
			_draw_fabrik(self.aim, GAME_SETTINGS.hand_node)
		ARM_STATE.AIMING:
			#_draw_forwards()
			# If we are moving around, we go towards the hand
			_draw_fabrik(_get_end_position(), 1)
		ARM_STATE.PULLING_BACK:
			_process_pullback()
			_draw_constraints()


func _draw_forwards() -> void:
	_process_forwards()
	_draw_constraints()


func _draw_fabrik(end_point: Vector2, end_node: int) -> void:
	_process_backwards(end_point, end_node)
	_process_forwards()
	#_process_constraints()
	_draw_constraints()


func _process_constraints() -> void:
	for i in range(len(constraints) - 1):
		if constraints[i].is_base:
			#print("Calling back ", i)
			_process_constraints_recursive(i)

func _process_constraints_recursive(start_index: int) -> void:
	#constraints[start_index].position = _get_body_position()
	draw_circle(constraints[start_index].position, constraints[start_index].radius, Color.RED)
	for i in range(start_index, len(constraints) - 1):
		var curr_node := constraints[i]
		var next_node := constraints[i + 1]
		_calculate_constraint(curr_node, next_node, true, true)
		

func _process_backwards(end_point: Vector2, end_node: int) -> void:
	# Set the end constraint to the end effector
	var target_pos = end_point
	constraints[-end_node].position = target_pos
	# We want to update all the constraint positions up to the first constraint
	# We don't want to set the angle and direction of the first constraint
	for i in range(len(constraints) - end_node, 0, -1):
		var curr_node := constraints[i]
		var next_node := constraints[i - 1]
		_calculate_constraint(curr_node, next_node, false, true)


func _process_pullback() -> void:
	# Set the start constraint to the origin
	constraints[0].position = _get_body_position()
	for i in range(len(constraints) - 1):
		var curr_node := constraints[i]
		var next_node := constraints[i + 1]
		_calculate_constraint(curr_node, next_node, false, false)

func _process_forwards() -> void:
	# Set the start constraint to the origin
	constraints[0].position = _get_body_position()
	for i in range(len(constraints) - 1):
		var curr_node := constraints[i]
		var next_node := constraints[i + 1]
		_calculate_constraint(curr_node, next_node, true, true)

func _calculate_constraint(curr: Constraint, next: Constraint, _query_ray: bool, constraint_distance: bool) -> void:
	var next_position := next.position
	
	#var space_state = get_world_2d().direct_space_state
	#var query = PhysicsRayQueryParameters2D.create(curr.position, next.position, Game.OBSTACLE_COLLISION_MASK)
	#var result = space_state.intersect_ray(query)
	#if result and query_ray:
		#print("Hit ray")
		#next_position = result['position']
		#draw_circle(next_position - global_position, 5.0, Color.RED)
		#next.is_base = true
	#else:
		#next.is_base = false

	var node_distance := GAME_SETTINGS.max_reach / len(constraints)
	var difference := next_position - curr.position
	
	var angle_difference = angle_difference(curr.angle, difference.angle())
	#print("Current Angle ", curr.angle, " Difference Angle ", difference.angle(), " Angle Difference ", angle_difference)
	
	#debug_line(curr.position, curr.angle, Color.WHITE, 10.0)
	#debug_line(curr.position, difference.angle(), Color.BLACK, 5.0)

	var lock_angle := false
	if abs(angle_difference) > curr.max_angle:
		#print(str("Angle Diff ", angle_difference, " Curr Angle: ", curr.angle), " New Angle ", new_angle)
		var locked_angle = curr.angle + sign(angle_difference) * PI * 0.25
		#debug_line(curr.position, locked_angle, Color.BLUE, 3.0)
		#difference = Vector2.from_angle(locked_angle) * difference.length()
		lock_angle = true

	curr.angle = difference.angle()

	# If the constraint is past the distance per node, we wanna lock it
	if constraint_distance and difference.length() >= node_distance:
		var new_position := curr.position + difference.normalized() * node_distance
		next.position = new_position
	else:
		next.position = curr.position + difference

func debug_line(pos: Vector2, angle: float, colour: Color, width: float) -> void:
	draw_line(pos - global_position, pos - global_position + Vector2.from_angle(angle) * 50.0, colour, width)


func _draw_constraints() -> void:
	var coords: Array[Vector2]= []
	# Get the left side
	for i in range(len(constraints) - 2):
		var curr_left := get_parametric(constraints[i], PI * 0.5)
		var next_left := get_parametric(constraints[i + 1], PI * 0.5)
		coords.append(curr_left)
		coords.append(next_left)
	
	var last_constraint := constraints[-1]
	var left_1 := get_parametric(last_constraint, -PI * 0.5)
	var left_2 := get_parametric(last_constraint, -PI * 0.8)
	var left_3 := get_parametric(last_constraint, -PI * 1)
	
	var right_1 := get_parametric(last_constraint, PI * 1)
	var right_2 := get_parametric(last_constraint, PI * 0.8)
	var right_3 := get_parametric(last_constraint, PI * 0.5)
	coords.append(left_1)
	coords.append(left_2)
	coords.append(left_3)
	coords.append(right_1)
	coords.append(right_2)
	coords.append(right_3)
	
	for i in range(len(constraints) - 2, 0, -1):
		var curr_right := get_parametric(constraints[i], -PI * 0.5)
		var next_right := get_parametric(constraints[i - 1], -PI * 0.5)
		coords.append(curr_right)
		coords.append(next_right)

	for constraint in constraints:
		_draw_constraint(constraint)
	var fill: PackedVector2Array = Global.pack_array(coords)
	#draw_polygon(fill, [fill_colour])
	#draw_polyline(fill, border_colour, GAME_SETTINGS.tentacle_width)

func get_parametric(constraint: Constraint, angle: float) -> Vector2:
	var pos := constraint.position - global_position
	var radius := constraint.radius
	var x := pos.x + radius * cos(constraint.angle + angle)
	var y := pos.y + radius * sin(constraint.angle + angle)
	return Vector2(x, y)

func _draw_constraint(constraint: Constraint) -> void:
	var draw_pos = constraint.position - global_position
	draw_circle(draw_pos, constraint.radius + 3.0, fill_colour)
