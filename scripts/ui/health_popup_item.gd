class_name HealthPopupItem
extends Control

const HEART_BROKEN = preload("res://art/ui/heart_broken.png")
@onready var image = $Image as TextureRect

const EXPAND = 1.1
const CONTRACT = 0.8
const ANIM_TIME = 0.1
const WAIT_TIME = 1.0
var alive := false

var tween: Tween

func play_anim() -> void:
	adjust_pivot()
	tween = create_tween().set_loops()
	tween.tween_property(self, "scale", Vector2.ONE * EXPAND, ANIM_TIME).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE * CONTRACT, ANIM_TIME).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, ANIM_TIME).set_ease(Tween.EASE_OUT)
	tween.tween_interval(WAIT_TIME)

func adjust_pivot() -> void:
	pivot_offset.x = image.size.x / 2
	pivot_offset.y = image.size.y / 2

func die() -> void:
	alive = false
	image.texture = HEART_BROKEN
	scale = Vector2.ONE
	tween.kill()
