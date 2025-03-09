class_name PlayerPopup
extends Control

@export var player_id := 0

@onready var health_popup := %HealthPopup as HealthPopup
@onready var ink_popup := %InkPopup as InkPopup


func init() -> void:
	health_popup.init(player_id)
	ink_popup.init(player_id)
