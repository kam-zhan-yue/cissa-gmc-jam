class_name Arms
extends Node2D

var arms: Array[Arm] = []

const STRIDE_DISTANCE = 150.0
const ARM_SPEED = 900.0
@onready var octopus: Octopus = $".."

const RESTRICTION_ANGLE = 10.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var children = get_children()
	for child in children:
		if child is Arm and child is not PrimaryArm:
			arms.append(child as Arm)
	var positions = get_positions()
	for i in range(len(positions)):
		arms[i].target = positions[i]
		arms[i].arm_state = Arm.ARM_STATE.SEARCHING

func _process(delta: float) -> void:
	#var direction = 
	var positions = get_positions()
	for i in range(len(positions)):
		arms[i].target = positions[i]
	queue_redraw()

func get_positions() -> Array[Vector2]:
	var positions: Array[Vector2] = []
	var target_direction = octopus.get_direction()
	var player_angle := atan2(-target_direction.y, target_direction.x)

	
	var start_angle := deg_to_rad(RESTRICTION_ANGLE) * 0.5
	var end_angle := 2 * PI - deg_to_rad(RESTRICTION_ANGLE) * 0.5
	print("Start ", start_angle)
	print("End ", end_angle)
	var angle_distance := (end_angle - start_angle) / (len(arms) + 1)
	for i in range(len(arms)):
		var angle := player_angle + start_angle + angle_distance * (i + 1)
		var x := Arm.MAX_REACH * cos(angle)
		var y := Arm.MAX_REACH * sin(angle)
		var target_pos = global_position + Vector2(x, -y)
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
