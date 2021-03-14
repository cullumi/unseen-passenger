class_name Player

extends KinematicBody2D

export (float) var walk_speed = 100
export(float) var sprint_speed = 300
export (float) var gravity = 200
export (bool) var controlled = false

signal cam_zoom

onready var body = $Sprites/BaseS
onready var limbs = $Sprites/LimbsAS
onready var cam_piv = $CamPivot
onready var focus_detector = $FocusDetector
onready var move_dir : Vector2 = Vector2()
onready var look_dir : Vector2 = Vector2()
onready var speed = walk_speed
onready var velocity = Vector2(0, gravity)
onready var is_flipped = false
onready var lock_view = false

const MASK_NEW = -2
const PREFER_OLD = -1
const NEUTRAL = 0
const PREFER_NEW = 1
const MASK_OLD = 2

# Inputs
var move_left = false
var move_right = false
var look_left = false
var look_right = false
var look_up = false
var look_down = false
var sprint = false
var view_changed = false
var is_focusing = false
var focus_zoom_scale = 0.75

var walk_audio_loop = null

var debug = false

func _ready():
#	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	toggle_focus(false)

#func _on_joy_connection_changed(device_id, connected):
#	if connected:
#		print(Input.get_joy_name(device_id))
#	else:
#		print("Keyboard")

func _input(event):
	if (controlled):
		var move_state_changed = false
		var m_dir = Vector2()
		var adj_weight = PREFER_NEW
		
	#	m_dir = Input.get_vector("move_left", "move_right").normalized()
		
		# Moving
		if event.is_action_pressed("move_left") : 
			if self.debug: print("Move left...")
			move_left = true
			m_dir = Vector2.LEFT
			move_state_changed = true
		elif event.is_action_released("move_left"):
			move_left = false
			m_dir = Vector2.RIGHT
			adj_weight = MASK_NEW
			move_state_changed = true
		elif event.is_action_pressed("move_right"):
			if self.debug: print("Move right...")
			move_right = true
			m_dir = Vector2.RIGHT
			move_state_changed = true
		elif event.is_action_released("move_right"):
			move_right = false
			move_left = false
			m_dir = Vector2.LEFT
			adj_weight = MASK_NEW
			move_state_changed = true
		# Looking
		elif event.is_action_pressed("look_left"):
			look_left = true
		elif event.is_action_released("look_left"):
			look_left = false
		elif event.is_action_pressed("look_right"):
			look_right = true
		elif event.is_action_released("look_right"):
			look_right = false
		elif event.is_action_pressed("look_up"):
			look_up = true
		elif event.is_action_released("look_up"):
			look_up = false
		elif event.is_action_pressed("look_down"):
			look_down = true
		elif event.is_action_released("look_down"):
			look_down = false
		elif event.is_action_pressed("player_sprint"):
			if self.debug: print("Sprint!")
			sprint = true
	#		speed = sprint_speed
		elif event.is_action_released("player_sprint"):
			sprint = false
	#		speed = walk_speed
		elif event.is_action_pressed("player_view_lock"):
			lock_view = not lock_view
		# Focus
		elif (event.is_action_pressed("player_focus")):
			toggle_focus(true)
		elif (event.is_action_released("player_focus")):
			toggle_focus(false)
		
		if move_state_changed:
			move_dir = adjust_dir_vector(move_dir, m_dir, adj_weight)
#		print(move_dir)

func _process(_delta):
	if (controlled):
		update_view()
		update_focus()
		if (velocity.x != 0):
			if (speed == walk_speed):
				limbs.animation = "Walking"
			else:
				limbs.animation = "Running"
		else:
			limbs.animation = "Idle"

func _physics_process(_delta):
	if (controlled):
		if sprint and not is_strafing():
			speed = sprint_speed
		elif sprint and is_strafing():
			speed = (walk_speed+sprint_speed)/2 * 0.95
		elif is_strafing():
			speed = walk_speed*0.75
		else:
			speed = walk_speed
		if (!is_on_floor()):
			velocity.y = +gravity
		else:
			velocity.y = 0
		velocity.x = move_dir.x * speed
		var ev = move_and_slide(velocity)
		
		if (velocity.x != 0 and not walk_audio_loop):
			walk_audio_loop = Audio.start_sound_loop(Audio.CHAR_WALK, self)
		elif velocity.x == 0 and walk_audio_loop:
			Audio.stop_sound_loop(walk_audio_loop)
			walk_audio_loop = null

func is_strafing():
	return (is_flipped and move_dir.x > 0) or (not is_flipped and move_dir.x < 0)

func update_view():
	var look = look_dir
	if (sprint):
		if move_left and move_dir.x < 0:
#			print("Swapping to the left...")
			look_dir = adjust_dir_vector(look_dir, Vector2.LEFT, PREFER_NEW)
		elif move_right and move_dir.x > 0:
			look_dir = adjust_dir_vector(look_dir, Vector2.RIGHT, PREFER_NEW)
	else:
		if look_left:
			look_dir = adjust_dir_vector(look_dir, Vector2.LEFT, PREFER_NEW)
		if look_right:
			look_dir = adjust_dir_vector(look_dir, Vector2.RIGHT, PREFER_NEW)
	
	if (look.x != look_dir.x or look.y != look_dir.y):
		view_changed = true
	
	if (view_changed):
#		print("View Changed...")
		if (look_dir.x < 0):
			set_flip_h(true)
		elif (look_dir.x > 0):
			set_flip_h(false)
#		print(look_dir)
	view_changed = false

func update_focus():
	if (is_focusing):
		focus_detector.look_at(get_global_mouse_position())
		var rot = focus_detector.rotation_degrees
		if rot > 270:
			focus_detector.rotation_degrees = rot - 270 - 90
		elif rot < -90:
			focus_detector.rotation_degrees = rot + 90 + 270
		if rot >= 90 and rot <= 270:
			if not is_flipped:
				set_flip_h(true)
		elif rot >= -90 and rot < 90:
			if is_flipped:
				set_flip_h(false)

func toggle_focus(active = null):
	if (active == null):
		active = !is_focusing
	is_focusing = active
	focus_detector.set_active(active)
	if (is_focusing):
		focus_detector.start_blinking()
		emit_signal("cam_zoom", focus_zoom_scale)
	else:
		focus_detector.stop_blinking()
		emit_signal("cam_zoom")

func set_flip_h(flipped:bool):
	if (not lock_view):
		is_flipped = flipped
		set_scale_flip(flipped, cam_piv)
		body.set_flip_h(flipped)
		limbs.set_flip_h(flipped)
		
func set_scale_flip(flipped:bool, tfrmbl:Node2D):
	if ((flipped and tfrmbl.scale.x > 0) or (!flipped and tfrmbl.scale.x < 0)):
		tfrmbl.scale.x *= -1
		return true
	return false

func adjust_dir_vector(dir1: Vector2, dir2 : Vector2, weight: int = 0, debug : bool = false, enable : bool = true):
	# Assumes both values of the Vector2 are either 1, 0, or -1.
	# weights: 2s mask values, 1s prioritize values, and 0s are neutral. 
	debug = false
	if debug : print("Vec1: " + String(dir1) + " >> " + String(dir2) + " w/ " + String(weight) + " & " + String(enable))
	if (not enable):
		dir2 *= -1
	match weight:
		-2: dir2 *= dir1.normalized().abs()
		-1: dir1 *= 2
		1: dir2 *= 2
		2: dir1 *= dir2.normalized().abs()
	var dirSum = dir1 + dir2
	if debug : print(">> " + String(dirSum))
	return dirSum.normalized()


func _on_FocusDetector_body_entered(body):
#	if (body.is_in_group("detectable")):
#		body.detected(true)
	pass

func _on_FocusDetector_body_exited(body):
	if (controlled):
		if (body.is_in_group("detectable")):
			body.detected(false)
	pass
