class_name InkPopup
extends Control

#NEED HELP

@onready var player_1_ink: RichTextLabel = $Player1Ink
@onready var player_2_ink: RichTextLabel = $Player2Ink

var player1_ui_label : RichTextLabel = null
var player2_ui_label : RichTextLabel = null

var ui_labels = {}

var player1 : Node
var player2 : Node

func _ready() -> void:
	player1_ui_label = get_node("")
	player2_ui_label = get_node("")
	
	player1 = get_node("")
	player2 = get_node("")
	#update_ui()

func update_ui() -> void:
	var player1_ink = player1.get("ink")
	var player2_ink = player2.get("ink")
	
	if player1_ui_label:
		player1_ui_label.text = "Player 1 Ink: " + str(int(player1_ink))
		
	if player2_ui_label:
		player2_ui_label.text = "Player 2 Ink: " + str(int(player2_ink))

func _process(delta: float) -> void:
	update_ui() 
