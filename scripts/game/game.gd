extends Node

signal on_killzone_enter(player_id: int)
signal on_killzone_exit(player_id: int)
signal on_killzone_timer(player_id :int, time: float)
signal on_player_dead(player_id: int)

var title := "This is a title"

var player_one: Octopus
var player_two: Octopus

func init(one: Octopus, two: Octopus):
	player_one = one
	player_two = two

func respawn_player(player_id: int):
	pass

func kill_player(player_id: int):
	print("Killing player ", player_id)
	pass
