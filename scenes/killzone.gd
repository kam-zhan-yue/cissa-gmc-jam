extends Area2D

@onready var timer = $Timer

var total_time := 0.0
var timer_running := false

func _process(delta: float) -> void:
	var bodies = get_players()
	var total_players = len(bodies)
	if total_players < 2 and not timer_running:
		start_timer()
	elif total_players == 2 and timer_running:
		stop_timer()

	print(bodies)

func start_timer() -> void:
	timer_running = true
	timer.start()
	
func stop_timer() -> void:
	timer_running = false
	timer.stop()

func get_players() -> Array[Octopus]:
	var bodies = get_overlapping_bodies()
	var players: Array[Octopus] = []
	for body in bodies:
		if body is Octopus:
			players.append(body)
	return players
	

func _on_timer_timeout():
	print("game!")
	get_tree().reload_current_scene()
	
