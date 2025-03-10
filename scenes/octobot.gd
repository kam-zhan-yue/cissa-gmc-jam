class_name Octobot
extends Node2D

@onready var octopus: Octopus = %Octopus

var state := STATE.ENTER

enum STATE {
	ENTER,
	SEARCH_ITEM,
	CHASE_PLAYER
}

func _ready() -> void:
	pass

func get_body() -> Octopus:
	var child = get_child(0) as Octopus
	return child

func get_player() -> Octopus:
	return Game.player_one

func _process(delta: float) -> void:
	var player := get_player()
	if not player: return
	
	if state == STATE.ENTER:
		# If player is not holding an item -> go into search item
		if not octopus.is_holding_item():
			state = STATE.SEARCH_ITEM
		else:
			state = STATE.CHASE_PLAYER
	elif state == STATE.SEARCH_ITEM:
		var items = Game.items
		print(items)
		var item_to_grab = Game.items[0]
		octopus.grab_towards(item_to_grab.global_position)
	elif state == STATE.CHASE_PLAYER:
		octopus.steer_towards(player.global_position)
	
