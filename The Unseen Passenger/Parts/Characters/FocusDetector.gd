extends Area2D

onready var collider = $CollisionPolygon2D
var active = false

func set_active(active:bool):
	self.active = active
	collider.disabled = !active
