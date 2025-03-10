class_name Octobot
extends Node2D

@onready var octopus: Octopus = %Octopus

var state := STATE.ENTER

var swing_speed = 10.0
var swing_range = 300.0
var swing_timer := 0.0
var base_target_x := 0.0
var distance_to_attack := 200.0





enum STATE {
	ENTER,
	SEARCH_ITEM,
	CHASE_PLAYER,
	RETURN,
	DASH

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
	
	# State ENTER for when the game starts
	if state == STATE.ENTER:
		# If player is not holding an item -> go into search item
		if not octopus.is_holding_item():
			state = STATE.SEARCH_ITEM
		else:
			state = STATE.CHASE_PLAYER

	
	# SEARCH_ITEM State
	elif state == STATE.SEARCH_ITEM:
		
		var items = Game.items
		var closest_item = items[0]
		var closest_distance = octopus.global_position.distance_to(items[0].global_position)
		
	
		# Loops through all items and finds the closest ones
		for i in range(len(items)):
			if octopus.global_position.distance_to(items[i].global_position) < closest_distance:
				closest_item = items[i]
			
		# Grabs and goes towards the closest item
		octopus.grab_towards(closest_item.global_position)
		octopus.steer_towards(closest_item.global_position)
		
			
		
		
		# After octopus has grabbed the item
		if octopus.is_holding_item():
			print("bot is holding item")
			state = STATE.CHASE_PLAYER


	
	# CHASE PLAYER STATE
	elif state == STATE.CHASE_PLAYER:
		octopus.steer_towards(player.global_position)
		
		# Attack the player with the arm if close enough
		var distance_to_player = octopus.global_position.distance_to(player.global_position)
		var origin = Vector2.ZERO
		var distance_from_origin = octopus.global_position.distance_to(origin)

		# If not close enough, move towards player
		if distance_to_player > distance_to_attack: 
			octopus.grab_towards(player.global_position)
			swing_arm(delta, player.global_position)

			
			# If too far, go back to middle
			if distance_from_origin > 500:
				state = STATE.RETURN
		
		
		# If not holding an item, chaneg state to SEARCH_ITEM
		elif not octopus.is_holding_item():
			print('octopus searching for item')
			state = STATE.SEARCH_ITEM
			
			
			
		# If the player is too close, create space
		elif distance_to_player < distance_to_attack:
			
			# move away
			octopus.steer_away(player.global_position)
			
		
		
			
			
		# Attack
		else:
			
			# Swinging arm for long things
			print('attacking')
			
			# SOMETHING HERE FOR THROWING




	# RETURN State
	elif state == STATE.RETURN:
		
		var origin = Vector2.ZERO
		var distance_from_origin = octopus.global_position.distance_to(origin)

		octopus.steer_towards(origin)
		
		# use the ink boost if out of bounds
		if distance_from_origin > 750:
			
			pass
		
		if distance_from_origin < 100:
			state = STATE.SEARCH_ITEM


# Function for swinging arm
func swing_arm(delta: float, target_position: Vector2) -> void:
	# swings hand back and forth horizontally
	if base_target_x == 0:
		base_target_x = target_position.x

	
	swing_timer += delta
	var swing_offset = sin(swing_timer * swing_speed) * swing_range
	target_position.x = base_target_x + swing_offset
	
	octopus.grab_towards(target_position)
