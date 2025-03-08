extends Control

@onready var octopus := $".." as Octopus
@onready var rich_text_label := $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.on_killzone_enter.connect(_show_killzone_text)
	Game.on_killzone_exit.connect(_hide_killzone_text)
	Game.on_killzone_timer.connect(_update_killzone_text)
	Global.set_inactive(rich_text_label)

func _show_killzone_text(player_id: int) -> void:
	if player_id == octopus.player_id:
		Global.set_active(rich_text_label)

func _hide_killzone_text(player_id: int) -> void:
	if player_id == octopus.player_id:
		Global.set_inactive(rich_text_label)

func _update_killzone_text(player_id: int, time: float) -> void:
	if player_id == octopus.player_id:
		rich_text_label.text = str(time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
