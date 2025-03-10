extends Node2D

@export var max_angle := PI * 0.25
@onready var base: Sprite2D = $Base
@onready var ball: Sprite2D = $Ball

var original_angle := 0.0

func _ready() -> void:
	var difference := ball.global_position - base.global_position
	var angle := difference.angle()
	original_angle = angle


func _process(delta: float) -> void:
	var camera = get_viewport().get_camera_2d()
	var mouse_pos := camera.get_global_mouse_position()
	ball.global_position = mouse_pos
	queue_redraw()

func _draw() -> void:
	var difference := ball.global_position - base.global_position
	var angle := difference.angle()
	var original_target := Vector2.from_angle(original_angle) * difference.length()
	
	var real := Vector2.from_angle(angle) * difference.length()
	var target := real
	var start := base.global_position - global_position
	
	var angle_difference := angle_difference(angle, original_angle)
	if abs(angle_difference) > max_angle:
		var locked_angle = original_angle - sign(angle_difference) * max_angle
		target = Vector2.from_angle(locked_angle) * difference.length()

	draw_line(start, start + original_target, Color.BLUE, 2.0)
	draw_line(start, start + target, Color.RED, 2.0)
	draw_line(start, start + real, Color.BLACK, 2.0)
