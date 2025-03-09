class_name Constraint
extends Object

var position: Vector2
var radius: float
var angle: float
var is_base: bool

func _init(p: Vector2 = Vector2.ZERO, r: float = 0.0, a: float = 0.0, b := false) -> void:
	self.position = p
	self.radius = r
	self.angle = a
	self.is_base = b
