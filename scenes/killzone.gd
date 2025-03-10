extends Area2D

const GAME_SETTINGS = preload("res://resources/game_settings.tres")

@onready var player1timer: Timer = $Player1Timer
@onready var player2timer: Timer = $Player2Timer

var timers: Dictionary[int, Timer] = {}

func _ready() -> void:
	player1timer.wait_time = GAME_SETTINGS.killzone_time
	player2timer.wait_time = GAME_SETTINGS.killzone_time
	timers[0] = player1timer
	timers[1] = player2timer

func _process(_delta: float) -> void:
	for key in timers:
		if not timers[key].is_stopped():
			Game.on_killzone_timer.emit(key, timers[key].time_left)


func _on_body_exited(body: Node2D) -> void:
	if body is Octopus:
		on_player_exited(body.player_id)
	elif body is Item:
		body.enter_killzone()


func _on_body_entered(body: Node2D) -> void:
	if body is Octopus:
		on_player_entered(body.player_id)
	elif body is Item:
		body.exit_killzone()


func on_player_exited(player_id: int) -> void:
	if timers[player_id].is_stopped():
		print(str("Player ", player_id, " Exited"))
		timers[player_id].start()
		Game.on_killzone_enter.emit(player_id)


func on_player_entered(player_id: int) -> void:
	if not timers[player_id].is_stopped():
		print(str("Player ", player_id, " Entered"))
		timers[player_id].stop()
		Game.on_killzone_exit.emit(player_id)


func _on_player_1_timer_timeout() -> void:
	Game.kill_player(0)


func _on_player_2_timer_timeout() -> void:
	Game.kill_player(1)
