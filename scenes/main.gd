extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#add both players as targets for the dynamic camera
	$DynamicCamera2D.add_target($PlayerOne)
	$DynamicCamera2D.add_target($PlayerTwo)
	
	#set camera limits
