class_name Arms
extends Node2D

var arms: Array[Arm] = []

const STRIDE_DISTANCE = 100.0
const ARM_SPEED = 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var children = get_children()
	for child in children:
		if child is Arm and child is not PrimaryArm:
			arms.append(child as Arm)
	var angle_distance = 2 * PI / len(arms)
	for i in range(len(arms)):
		var x := Arm.MAX_REACH * cos(angle_distance * i)
		var y := Arm.MAX_REACH * sin(angle_distance * i)
		arms[i].aim = global_position + Vector2(x, -y)
		arms[i].arm_state = Arm.ARM_STATE.SEARCHING

func _process(delta: float) -> void:
	var angle_distance = 2 * PI / len(arms)
	for i in range(len(arms)):
		var x := Arm.MAX_REACH * cos(angle_distance * i)
		var y := Arm.MAX_REACH * sin(angle_distance * i)
		var target_pos = global_position + Vector2(x, -y)
		var difference = target_pos - arms[i].aim
		if difference.length() >= STRIDE_DISTANCE:
			arms[i].aim = lerp(arms[i].aim, target_pos, STRIDE_DISTANCE / difference.length())
	
	#await Global.wait(1.0)
	#for i in range(len(arms)):
		#if arms[i] is not PrimaryArm:
			#arms[i].arm_state = Arm.ARM_STATE.IDLE
	
