class_name HUD
extends Control

@onready var player_one_popup: PlayerPopup = %PlayerOnePopup
@onready var player_two_popup: PlayerPopup = %PlayerTwoPopup

func init() -> void:
	player_one_popup.init()
	player_two_popup.init()
