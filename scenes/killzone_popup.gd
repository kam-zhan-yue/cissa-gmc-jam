extends Control

@onready var rich_text_label: RichTextLabel = %RichTextLabel

func _ready() -> void:
	Game.on_killzone_enter.connect(_show_killzone_text)
	Game.on_killzone_exit.connect(_hide_killzone_text)
	Game.on_killzone_timer.connect(_update_killzone_text)

func _show_killzone_text() -> void:
	print('show!')

func _hide_killzone_text() -> void:
	print('hide!')

func _update_killzone_text(time: float) -> void:
	rich_text_label.text = str(time)
