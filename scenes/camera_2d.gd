class_name DynamicCamera
extends Camera2D

@export var cam_move_speed = 0.5
@export var cam_zoom_speed = 0.05
@export var cam_min_zoom=0.1
@export var cam_max_zoom=1
@export var margin = Vector2(400, 200)
@export var bounds: Rect2

var targets = []

@onready var screen_size = get_viewport_rect().size

func add_target(t):
	if not t in targets:
		targets.append(t)
	
func remove_target(t):
	if t in targets:
		targets.erase(t)

func _process(delta):
	if !targets:
		return
		#keep the camera centred between targets
	var p = Vector2.ZERO
	for target in targets:
		p+=target.position
	p/= targets.size()
	position = lerp(position, p, cam_move_speed)
	
	#find the zoom that will contain all targets
	var r = Rect2(position, Vector2.ONE)
	for target in targets:
		r = r.expand(target.position)
	r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	var d = max(r.size.x, r.size.y)
	var z
	if r.size.x > r.size.y * screen_size.aspect():
		var val = screen_size.x / r.size.x
		z = clamp(val, cam_min_zoom, cam_max_zoom)
	else:
		var val = screen_size.y / r.size.y
		z = clamp(val, cam_min_zoom, cam_max_zoom)
	zoom = lerp(zoom, Vector2.ONE * (z), cam_zoom_speed)
