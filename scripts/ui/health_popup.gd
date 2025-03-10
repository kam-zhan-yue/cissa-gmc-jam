class_name HealthPopup
extends HBoxContainer

var player_id := 0

const GAME_SETTINGS = preload("res://resources/game_settings.tres")
const HEALTH_POPUP_ITEM = preload("res://scenes/ui/health_popup_item.tscn")
const HEART_FULL = preload("res://art/ui/heart_full.png")

var health_items: Array[HealthPopupItem]= []

func init(id: int) -> void:
	self.player_id = id
	for i in range(GAME_SETTINGS.max_health):
		var health_popup_item = HEALTH_POPUP_ITEM.instantiate() as HealthPopupItem
		self.add_child(health_popup_item)
		health_popup_item.play_anim()
		health_items.append(health_popup_item)
	Game.on_player_health_changed.connect(on_health_changed)
	if player_id == 1:
		health_items.reverse()

func on_health_changed(id: int, health: int) -> void:
	if id != self.player_id:
		return
	for i in range(GAME_SETTINGS.max_health):
		if i > health - 1:
			health_items[i].die()
