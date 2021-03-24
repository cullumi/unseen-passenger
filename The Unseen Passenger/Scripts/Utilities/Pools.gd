extends Object

class_name Pools

static func segment_from_polygon(polygon):
	var segment_pool:PoolVector2Array = PoolVector2Array()
	var i = 0
	var j = 1
	while (i < polygon.size()):
		segment_pool.append(polygon[i])
		segment_pool.append(polygon[j])
		i += 1
		j += 1
		if j == polygon.size():
			j = 0
	return segment_pool

static func polygon_to_array_mesh(polygon, array_mesh):
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = polygon
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
