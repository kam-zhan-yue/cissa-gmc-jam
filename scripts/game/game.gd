extends Node

const GAME_SETTINGS = preload("res://resources/game_settings.tres")
const OBSTACLE_COLLISION_MASK = 1

signal on_killzone_enter(player_id: int)
signal on_killzone_exit(player_id: int)
signal on_killzone_timer(player_id :int, time: float)
signal on_player_dead(player_id: int)
signal on_player_health_changed(player_id: int, health: int)
signal on_game_over(winner_id: int)
signal on_start(mode: Mode)
signal on_tutorial

var player_one: Octopus
var player_two: Octopus
var camera: DynamicCamera
var player_one_checkpoint: Node2D
var player_two_checkpoint: Node2D
var items: Array[Item] = []

var player_1_lives := 0
var player_2_lives := 0
var LOSING_SCORE = 0

var mode := Mode.SINGLE

enum Mode {
	SINGLE,
	TWO,
	TUTORIAL,
}

func start_single_player() -> void:
	on_start.emit(Mode.SINGLE)

func start_two_player() -> void:
	on_start.emit(Mode.TWO)

func start_tutorial() -> void:
	on_start.emit(Mode.TUTORIAL)
	on_tutorial.emit()


func init(m: Mode, one: Octopus, two: Octopus, c: DynamicCamera, one_checkpoint: Node2D, two_checkpoint: Node2D, i: Array[Item]):
	mode = m
	player_one = one
	player_two = two
	camera = c
	player_one_checkpoint = one_checkpoint
	player_two_checkpoint = two_checkpoint
	player_1_lives = GAME_SETTINGS.max_health
	player_2_lives = GAME_SETTINGS.max_health
	camera.add_target(player_one)
	camera.add_target(player_two)
	items = i

func get_player(player_id: int) -> Octopus:
	return player_one if player_id == 0 else player_two

func get_checkpont(player_id: int) -> Node2D:
	return player_one_checkpoint if player_id == 0 else player_two_checkpoint

func kill_player(player_id: int):
	player_dies(player_id)

	
# Function for player loses lives when pushes out + respawns
func player_dies(player_id: int) -> void:
	if player_id == 0:
		if mode != Mode.TUTORIAL:
			player_1_lives -= 1
			on_player_health_changed.emit(player_id, player_1_lives)
		if player_1_lives <= 0:
			game_over(1)
		else:
			player1_respawns()
	elif player_id == 1:
		if mode != Mode.TUTORIAL:
			player_2_lives -= 1
			on_player_health_changed.emit(player_id, player_2_lives)
		if player_2_lives <= 0:
			game_over(0)
		else:
			player2_respawns()

# Function for player 1 respawn point 
func player1_respawns() -> void:
	respawn_player(0)

# Function for Player 2 respawn point
func player2_respawns() -> void:
	respawn_player(1)

func respawn_player(id: int) -> void:
	var player := get_player(id)
	player.deactivate()
	camera.remove_target(player)
	await Global.wait(GAME_SETTINGS.spawn_time)
	player.respawn(get_checkpont(id).global_position)
	camera.add_target(player)


# Function for when someone hits 0, game ends adn other player wins
func game_over(winner_id: int) -> void:
	# Resets player lives
	player_1_lives = 0
	player_2_lives = 0

	# Put some kind of game over UI here
	on_game_over.emit(winner_id)
