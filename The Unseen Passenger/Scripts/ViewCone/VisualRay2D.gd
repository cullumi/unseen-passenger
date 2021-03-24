extends Node2D

class_name VisualRay2D

export (Texture) var sprite_texture
export (Texture) var marker_texture
export (bool) var show_marker = false
export (float) var max_ray_length = 512
export (float) var max_sprite_width = 256

signal point_changed # returns a point in the global coordinate system

onready var ray:RayCast2D = $Ray
onready var sprite:Sprite = $Sprite
onready var marker:Sprite = $Marker

var enabled = false setget set_enabled

var last_point

func _ready():
	sprite.texture = sprite_texture
	marker.texture = marker_texture
	marker.visible = show_marker
	set_length(max_ray_length)

func set_enabled(enable):
	visible = enable
	ray.enabled = enable

func _physics_process(_delta):
	if ray.is_colliding():
		var gl_point = ray.get_collision_point()
		if last_point != gl_point:
			set_point(gl_point)
			last_point = gl_point
			emit_signal("point_changed", gl_point)
	else:
		var gl_point = to_global(ray.cast_to)
		if gl_point != last_point:
			last_point
			set_point(gl_point)
			emit_signal("point_changed", gl_point)

func set_length(length):
	ray.cast_to = ray.cast_to.normalized() * length

func set_point(gl_point):
	var marker_point = to_local(gl_point)
	var ray_point = ray.to_local(gl_point)
	marker.position = marker_point
	sprite.region_rect.size.x = ray_to_sprite(ray_point).x

func ray_to_sprite(value):
	return sprite.to_local(ray.to_global(value))
