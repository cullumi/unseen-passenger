extends KinematicBody2D

class_name UnseenPassenger

export (float) var back_speed = 80
export (float) var forward_speed = 120
export (float) var sneak_speed = 50
export(float) var sprint_speed = 300
export (float) var gravity = 200
export (float) var caution_time = 4

export (NodePath) var player_path
onready var player : Player = get_node(player_path)

onready var body = $Sprites/BaseS
onready var limbs = $Sprites/LimbsAS
onready var danger_radius : RayCast2D = $DangerRadius
onready var fear_radius : RayCast2D = $FearRadius
onready var caution_radius : RayCast2D = $CautionRadius
onready var caution_timer : Timer = $CautionTimer

onready var dir = Vector2()
onready var speed = sneak_speed
onready var velocity = Vector2(0, gravity)

var debug = true

var in_player_range = false

func _ready():
	UpStates.up = self
	UpStates.start("stalking")

func _process(delta):
	var transitioned = UpStates.auto_transition()
	if transitioned:
		if debug: print("Transitioned to: " + transitioned)
	UpStates.perform()

func _physics_process(delta):
	update_player_range()
	update_cornered()
	
	if (!is_on_floor()):
		velocity.y = +gravity
	else:
		velocity.y = 0
		
	velocity.x = dir.x * speed
	velocity = move_and_slide(velocity)
	
	if (velocity.x != 0):
		limbs.animation = "Walking"
	else:
		limbs.animation = "Idle"

func set_flip_h(flipped):
	body.set_flip_h(flipped)
	limbs.set_flip_h(flipped)

func update_cornered():
	var cornered = is_on_wall() and in_player_range and velocity.x < 0
	UpStates.set_status("cornered", cornered)

func update_player_range():
	var close = player_detected(danger_radius)
	var near = player_detected(fear_radius)
	var medium = player_detected(caution_radius)
	self.in_player_range = medium
	UpStates.set_status("player_close", close)
#	UpStates.set_status("player_near", near and not close)
	UpStates.set_status("player_near", medium and not close)
	UpStates.set_status("player_medium", medium and not near)
	UpStates.set_status("player_far", not medium)

func player_detected(raycast : RayCast2D):
	if (raycast.is_colliding()):
		var collider = raycast.get_collider()
		if (collider.is_in_group("player")):
			return true
	return false

func player_dir():
	return player.move_dir

func detected(detected:bool):
	if debug:
		print("detected")
#		UpStates.print_state()
#		UpStates.print_status()
	UpStates.set_status("seen", detected)

func start_caution_timer():
	UpStates.set_status("cautious", true)
	caution_timer.start(caution_time)

func _on_Caution_Timer_timeout():
	UpStates.set_status("cautious", false)
	caution_timer.stop()
