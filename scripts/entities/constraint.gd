class_name Constraint
extends Object

var position: Vector2
var radius: float
var angle: float


func _init(p: Vector2 = Vector2.ZERO, r: float = 0.0, a: float = 0.0) -> void:
	self.position = p
	self.radius = r
	self.angle = a
