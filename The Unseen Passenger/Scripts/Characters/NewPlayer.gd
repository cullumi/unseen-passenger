extends Character

class_name PlayerNew

export (bool) var controlled = false

signal cam_zoom

onready var cam_piv = $CamPivot
onready var focus_detector = $FocusDetector

var interactables = []

var look_dir:Vector2 = Vector2()
var view_changed = false
var is_focusing = false
var focus_zoom_scale = 0.75
var lock_view:bool = false

# State and Input

var play_state

func _ready() :
	print("Player Ready")
	play_state = PersistentState.new(self, PlayFactory)
	add_child(play_state)
	if controlled : add_child(PlayerInput.new(self))

func interact(): play_state.execute("interact")
# warning-ignore:shadowed_variable
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

func point_focus(_point:Vector2):
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

# Interaction

func trigger(open=null):
	for interactable in interactables:
		interactable.trigger(self, open)

func can_interact(): return interactables.size() > 0
func add_interactable(interactable): if not interactables.has(interactable) : interactables.append(interactable)
func remove_interactable(interactable): if interactables.has(interactable): interactables.erase(interactable)
func _on_Interactor_area_entered(area):
	if area.is_in_group("interactable"):
		play_state.execute("_add_interactable", area)
func _on_Interactor_area_exited(area):
	if area.is_in_group("interactable"):
		play_state.execute("_remove_interactable", area)
