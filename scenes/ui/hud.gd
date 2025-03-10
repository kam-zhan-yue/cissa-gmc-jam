class_name HUD
extends Control

@onready var player_one_popup: PlayerPopup = %PlayerOnePopup
@onready var player_two_popup: PlayerPopup = %PlayerTwoPopup

func _ready() -> void:
	Global.set_inactive(self)

func init() -> void:
	Global.set_active(self)
	player_one_popup.init()
	player_two_popup.init()	
