extends Camera2D

@export var cam_move_speed = 0.5
@export var cam_zoom_speed = 0.05
@export var cam_min_zoom=1.5
@export var cam_max_zoom=5
@export var margin = Vector2(400, 200)

var targets = []

@onready var screen_size = get_viewport_rect().size

func add_target(t):
		if not t in targets:
				targets.append(t)
	
