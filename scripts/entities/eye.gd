class_name Eye
extends Sprite2D

@onready var octopus: Octopus = $"../../.."

const MAX_DISTANCE = 5.0
const move_speed := 5.0

var original_pos := Vector2.ZERO

func _ready() -> void:
	original_pos = position

func _process(delta: float) -> void:
	var direction = octopus.get_input()
	var target_pos = original_pos
	if direction:
		target_pos += Vector2.DOWN * direction.length() * MAX_DISTANCE

	position = target_pos
