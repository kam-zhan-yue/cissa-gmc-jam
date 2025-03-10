class_name GameSettings
extends Resource

@export_category("Game")
@export var start_immediately := false
@export var single_player := false
@export var killzone_time := 2.0
@export var despawn_time := 3.0
@export var spawn_time := 3.0

@export_category("Player")
@export var max_health := 3
@export var movement_speed := 500.0
@export var burst_speed := 1000.0
@export var burst_time := 0.2
@export var burst_cost := 40.0
@export var dash_speed := 700.0
@export var dash_cost_rate := 20.0
@export var max_ink := 200.0
@export var ink_regen_rate := 10.0

@export_category("Items")
@export var throw_force := 2000.0
@export var throw_threshold := 0.7
@export var hit_force := 1000.0

@export_category("Tentacle")
@export var player_one_fill_colour := Color.INDIAN_RED
@export var player_one_border_colour := Color.DARK_RED
@export var player_two_fill_colour := Color.AQUAMARINE
@export var player_two_border_colour := Color.DARK_BLUE
@export var tentacle_width := 2.0
@export var tentacle_radius := 10.0
@export var max_reach := 200.0
@export var primary_tentacle_speed := 5000.0
@export var tentacle_speed := 1000.0
@export var total_nodes := 15
@export var hand_node := 4

@export_category("Animation")
@export var tentacle_radius_curve: Curve
@export var tentacle_angle_curve: Curve
@export var stride_distance := 150.0
@export var restriction_angle := -50.0
