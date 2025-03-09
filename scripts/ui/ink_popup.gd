class_name InkPopup
extends Control

#NEED HELP

@onready var player_1_ink: RichTextLabel = $Player1Ink
@onready var player_2_ink: RichTextLabel = $Player2Ink


func _ready() -> void:
	print("What")
	Game.player_one.on_ink_changed.connect(_one_ink_changed)
	Game.player_two.on_ink_changed.connect(_two_ink_changed)
	_one_ink_changed(Game.player_one.ink)
	_two_ink_changed(Game.player_two.ink)

func _one_ink_changed(ink: float) -> void:
	player_1_ink.text = "Player 1 Ink: " + str(int(ink))


func _two_ink_changed(ink: float) -> void:
	player_2_ink.text = "Player 2 Ink: " + str(int(ink))
