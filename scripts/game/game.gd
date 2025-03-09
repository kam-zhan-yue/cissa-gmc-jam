extends Node

const GAME_SETTINGS = preload("res://resources/game_settings.tres")
const OBSTACLE_COLLISION_MASK = 1

signal on_killzone_enter(player_id: int)
signal on_killzone_exit(player_id: int)
signal on_killzone_timer(player_id :int, time: float)
signal on_player_dead(player_id: int)
signal on_player_health_changed(player_id: int, health: int)
signal on_game_over(winner_id: int)


var player_one: Octopus
var player_two: Octopus
var player_one_checkpoint: Node2D
var player_two_checkpoint: Node2D

var player_1_lives := 0
var player_2_lives := 0
var LOSING_SCORE = 0

func init(one: Octopus, two: Octopus, one_checkpoint: Node2D, two_checkpoint: Node2D):
	player_one = one
	player_two = two
	player_one_checkpoint = one_checkpoint
	player_two_checkpoint = two_checkpoint
	player_1_lives = GAME_SETTINGS.max_health
	player_2_lives = GAME_SETTINGS.max_health

func get_player(player_id: int):
	return player_one if player_id == 0 else player_two	

func kill_player(player_id: int):
	print("Killing player ", player_id)
	player_dies(player_id)
	
	
# Function for player loses lives when pushes out + respawns
func player_dies(player_id: int) -> void:
	if player_id == 0:
		player_1_lives -= 1
		on_player_health_changed.emit(player_id, player_1_lives)
		if player_1_lives <= 0:
			game_over(1)
		else:
			player1_respawns()
	elif player_id == 1:
		player_2_lives -= 1
		on_player_health_changed.emit(player_id, player_2_lives)
		if player_2_lives <= 0:
			game_over(0)
		else:
			player2_respawns()

# Function for player 1 respawn point 
func player1_respawns() -> void:
	player_one.global_position = player_one_checkpoint.global_position

# Function for Player 2 respawn point
func player2_respawns() -> void:
	player_two.global_position = player_two_checkpoint.global_position


# Function for when someone hits 0, game ends adn other player wins
func game_over(winner_id: int) -> void:
	# Resets player lives
	player_1_lives = 0
	player_2_lives = 0

	# Put some kind of game over UI here
	on_game_over.emit(winner_id)
