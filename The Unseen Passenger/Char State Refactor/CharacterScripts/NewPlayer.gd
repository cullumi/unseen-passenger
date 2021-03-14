extends Character

class_name PlayerNew

export (bool) var controlled = false

signal cam_zoom

onready var cam_piv = $CamPivot
onready var focus_detector = $FocusDetector

var look_dir:Vector2 = Vector2()
var view_changed = false
var is_focusing = false
var focus_zoom_scale = 0.75
var lock_view:bool = false

# State and Input

var play_state

func _ready() :
	play_state = PersistentState.new(self, PlayFactory)
	add_child(play_state)
	if controlled : add_child(PlayerInput.new(self))

func set_look_dir(look_dir): play_state.execute("set_look_dir", look_dir)
func toggle_view_lock(): play_state.execute("toggle_view_lock")
func set_focus(focus): play_state.execute("set_focus", focus)

# High Level View

func focus():
	focus_detector.set_active(true)
	focus_detector.start_blinking()
	emit_signal("cam_zoom", focus_zoom_scale)

func idle():
	focus_detector = $FocusDetector
	focus_detector.stop_blinking()
	focus_detector.set_active(false)
	emit_signal("cam_zoom")	

func view_centered() 		: return Vectors.non_zero(look_dir)
func looking_horizontal()	: return Vectors.non_zero_x(look_dir)
func looking_vertical() 	: return Vectors.non_zero_y(look_dir)
func looking_left() 		: return Vectors.negative_x(look_dir)
func looking_right() 		: return Vectors.positive_x(look_dir)
func looking_up() 			: return Vectors.positive_y(look_dir)
func looking_down() 		: return Vectors.negative_y(look_dir)
func looking_along(axis_mask:Vector2) : return Vectors.aimed_along(look_dir, axis_mask)

# Low Level View

func flip_direction():
	flip_char_direction()
	set_view_flip(is_flipped)

func point_focus(point : Vector2):
	focus_detector.look_at(get_global_mouse_position())
	var rot = focus_detector.rotation_degrees
	if rot > 270:
		focus_detector.rotation_degrees = rot - 270 - 90
	elif rot < -90:
		focus_detector.rotation_degrees = rot + 90 + 270
	if (rot >= 90 and rot <= 270 and not is_flipped) or (rot >= -90 and rot < 90 and is_flipped):
		flip_direction()

func set_view_flip(flipped:bool):
	var tfrmbl = cam_piv
	if ((flipped and tfrmbl.scale.x > 0) or (!flipped and tfrmbl.scale.x < 0)):
		tfrmbl.scale.x *= -1
		return true
	return false

func update_view():
	pass
#	var look = look_dir
#	if (is_sprinting):
#		if move_left and move_dir.x < 0:
##			print("Swapping to the left...")
#			look_dir = adjust_dir_vector(look_dir, Vector2.LEFT, PREFER_NEW)
#		elif move_right and move_dir.x > 0:
#			look_dir = adjust_dir_vector(look_dir, Vector2.RIGHT, PREFER_NEW)
#	else:
#		if look_left:
#			look_dir = adjust_dir_vector(look_dir, Vector2.LEFT, PREFER_NEW)
#		if look_right:
#			look_dir = adjust_dir_vector(look_dir, Vector2.RIGHT, PREFER_NEW)
#
#	if (look.x != look_dir.x or look.y != look_dir.y):
#		view_changed = true
	
#	if (view_changed):
##		print("View Changed...")
#		if (look_dir.x < 0):
#			set_flip_h(true)
#		elif (look_dir.x > 0):
#			set_flip_h(false)
##		print(look_dir)
#	view_changed = false

func _on_FocusDetector_body_entered(body):
#	if (body.is_in_group("detectable")):
#		body.detected(true)
	pass

func _on_FocusDetector_body_exited(body):
	if (body.is_in_group("detectable")):
		body.detected(false)
	pass
