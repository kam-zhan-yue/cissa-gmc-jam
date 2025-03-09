extends Node

var WHITE = Color(1.0, 1.0, 1.0, 1.0)
var CLEAR = Color(1.0, 1.0, 1.0, 0.0)
var FADE_TIME = 0.3

const GRAB_LAYER = 4

var zoom := 5.0

func seconds(time: float) -> void:
	await get_tree().create_timer(time).timeout
	
func frame() -> void:
	var delta := get_process_delta_time()
	await wait(delta)

func wait_fade() -> void:
	await wait(FADE_TIME)

func wait(time: float) -> void:
	await get_tree().create_timer(time).timeout
	

func set_active(node: Node) -> void:
	active(node, true)
	
func set_inactive(node: Node) -> void:
	active(node, false)

func to_blue() -> Vector2:
	return Vector2(-1.0, 0.5).normalized()

func to_red() -> Vector2:
	return Vector2(1.0, -0.5).normalized()

func active(node: Node, is_active: bool) -> void:
	# Set visibility
	node.visible = is_active
	
	# Set general processing
	node.set_process(is_active)
	
	# Set physics processing
	node.set_physics_process(is_active)
	
	# Optionally, set input processing if needed
	if node.has_method("set_process_input"):
		node.set_process_input(is_active)
	
	# Optionally, set unhandled input processing if needed
	if node.has_method("set_process_unhandled_input"):
		node.set_process_unhandled_input(is_active)

func ease_out_quart(x: float) -> float:
	return 1 - pow(1 - x, 4)

func ease_out_sin(x: float) -> float:
	return sin((x * PI) / 2);

func flip_v(rotation: float) -> bool:
	var left_rotate = rotation > -PI*1.5 and rotation <-PI*0.5
	var right_rotate = rotation > PI*0.5 and rotation < PI*1.5
	return left_rotate or right_rotate

func wrap_center(text: String) -> String:
	return str("[center]", text, "[/center]")

func wrap_outline(text: String, size: float) -> String:
	return str("[outline_size=", size, "]", text, "[/outline_size]")

func fade_in(node: Node) -> void:
	await fade(node, FADE_TIME, true)
	
func fade_out(node: Node) -> void:
	await fade(node, FADE_TIME, false)

func fade(node: Node, fade_time: float, visible: bool) -> void:
	var tween = get_tree().create_tween()
	var target = WHITE if visible else CLEAR
	tween.tween_property(node, "modulate", target, fade_time)
	await wait_fade()

func get_collision_direction(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int, origin: Area2D) -> Vector2:
	var body_shape_owner_id = body.shape_find_owner(body_shape_index)
	var body_shape_owner = body.shape_owner_get_owner(body_shape_owner_id)
	var body_shape_2d = body.shape_owner_get_shape(body_shape_owner_id, 0)
	var body_global_transform = body_shape_owner.global_transform
	
	var area_shape_owner_id = origin.shape_find_owner(local_shape_index)
	var area_shape_owner = origin.shape_owner_get_owner(area_shape_owner_id)
	var area_shape_2d = origin.shape_owner_get_shape(area_shape_owner_id, 0)
	var area_global_transform = area_shape_owner.global_transform
	
	var collision_points = area_shape_2d.collide_and_get_contacts(area_global_transform,
									body_shape_2d,
									body_global_transform)
	if len(collision_points) == 2:
		var direction = collision_points[1] - collision_points[0]
		return direction
	else:
		return Vector2.ZERO
	
func get_input(id: int, command: String) -> String:
	return str("player_", id, "_", command)
