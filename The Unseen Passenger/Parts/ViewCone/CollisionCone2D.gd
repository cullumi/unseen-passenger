extends Area2D

class_name CollisionCone2D

export (Vector2) var origin = Vector2(9.208, -0.728)

var collider:CollisionShape2D
var enabled setget set_enabled
var poly_array = []

func _ready():
	collider = CollisionShape2D.new()
	add_child(collider)
	collider.shape = ConcavePolygonShape2D.new()
	poly_array = [origin, Vector2(), Vector2(), Vector2(), Vector2(), Vector2(), origin]
	transfer()

func set_enabled(enable):
	collider.disabled = not enable

# Note that all of the below ignore the first index

func transfer():
	collider.shape.segments = Pools.segment_from_polygon(poly_array)

func set_poly_count(count):
	print("Resizing Polygons")
	var old_count = poly_array.size()
	var new_count = count+1
	if old_count != new_count:
		poly_array.resize(new_count)
	if old_count < new_count:
		for i in range(old_count, new_count-1):
			poly_array[i] = poly_array[i-1]
	transfer()

func set_poly(index, vector):
	poly_array[index+1] = vector
	transfer()

func change_point(gl_point, index):
	var lc_point = to_local(gl_point)
	set_poly(index, lc_point)
