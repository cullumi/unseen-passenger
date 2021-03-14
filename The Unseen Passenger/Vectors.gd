
extends Object

class_name Vectors


# Movement Helpers

static func non_zero(dir:Vector2)  : return dir != Vector2()
static func non_zero_x(dir:Vector2): return dir.x != 0
static func non_zero_y(dir:Vector2): return dir.y != 0
static func negative_x(dir:Vector2): return dir.x < 0
static func positive_x(dir:Vector2): return dir.x > 0
static func positive_y(dir:Vector2): return dir.y > 0
static func negative_y(dir:Vector2): return dir.y < 0
static func aimed_along(dir:Vector2, axis_mask:Vector2): 
	var masked_dir = dir * axis_mask
	if axis_mask < Vector2(): return masked_dir < Vector2()
	elif axis_mask > Vector2(): return masked_dir > Vector2()
	else: return masked_dir == Vector2()


# Vector Adjustment Helper

# Vector Weight Constants
const MASK_NEW = -2
const PREFER_OLD = -1
const NEUTRAL = 0
const PREFER_NEW = 1
const MASK_OLD = 2

static func adjust_dir_vector(dir1:Vector2, dir2:Vector2, weight:int=0, enable:bool=true):
	# Assumes both values of the Vector2 are either 1, 0, or -1.
	# weights: 2s mask values, 1s prioritize values, and 0s are neutral. 
	if (not enable):
		dir2 *= -1
	match weight:
		-2: dir2 *= dir1.normalized().abs()
		-1: dir1 *= 2
		1: dir2 *= 2
		2: dir1 *= dir2.normalized().abs()
	var dirSum = dir1 + dir2
	return dirSum.normalized()
