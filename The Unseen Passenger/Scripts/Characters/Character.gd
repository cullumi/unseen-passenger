class_name Character

extends KinematicBody2D

export (float) var walk_speed = 120
export (float) var sneak_speed = 50
export (float) var sprint_speed = 300
export (float) var strafe_modifier = 0.75
export (float) var gravity = 200

onready var sound_players = $CharacterSounds
onready var body = $Sprites/BaseS
onready var limbs:AnimatedSprite = $Sprites/LimbsAS
var flippable:Array = []

const ANIM_WALK = "Walking"
const ANIM_RUN = "Running"
const ANIM_IDLE = "Idle"

var move_dir:Vector2 = Vector2()
var base_speed:float = walk_speed
var speed:float  = walk_speed
var velocity:Vector2 = Vector2(0, gravity)
var final_velocity:Vector2 = Vector2()
var is_flipped:bool = false
var sprint:bool = false
var sneak:bool = false

# State

var move_state

func _ready() : 
	print("Character Ready")
	move_state = PersistentState.new(self, CharFactory)
	add_child(move_state)

func set_move_dir(new_move_dir) : move_state.execute("set_move_dir", new_move_dir)
func set_sneak(new_sneak) : move_state.execute(("set_sneak"), new_sneak)
func set_sprint(new_sprint) : move_state.execute("set_sprint", new_sprint)
func flip_char_direction() : move_state.execute("flip_direction")

# High Level Movement

func sneak():
	print("Sneaking")
	base_speed = sneak_speed
	speed = sneak_speed
	limbs.play(ANIM_WALK)
	stop_walk_sounds()

func walk():
	print("Walking")
	base_speed = walk_speed
	speed = walk_speed
	limbs.play(ANIM_WALK)

func run():
	print("Running")
	base_speed = sprint_speed
	speed = sprint_speed
	limbs.play(ANIM_RUN)

func wait():
	print("Idling")
	base_speed = base_speed
	speed = 0
	limbs.play(ANIM_IDLE)
	stop_walk_sounds()

func strafe(target_speed=null):
#	print("Strafing")
	if target_speed:
		speed = (base_speed + target_speed)/2 * strafe_modifier
	else:
		speed = base_speed * strafe_modifier

func is_sprinting()		: return sprint and moving_horizontal()
func is_strafing()		: return (is_flipped and move_dir.x > 0) or (not is_flipped and move_dir.x < 0)
func moving() 			: return Vectors.non_zero(move_dir)
func moving_horizontal(): return Vectors.non_zero_x(move_dir)
func moving_vertical() 	: return Vectors.non_zero_y(move_dir)
func moving_left() 		: return Vectors.negative_x(move_dir)
func moving_right() 	: return Vectors.positive_x(move_dir)
func moving_up() 		: return Vectors.positive_y(move_dir)
func moving_down() 		: return Vectors.negative_y(move_dir)
func moving_along(axis_mask:Vector2) : return Vectors.aimed_along(move_dir, axis_mask)

# Low Level Movement

func flip_direction():
	flip_char_direction()

func construct_velocity():
	if (!is_on_floor()):
		velocity.y = +gravity
	else:
		velocity.y = 0
	velocity.x = move_dir.x * speed

func apply_velocity():
	final_velocity = move_and_slide(velocity, Vector2.UP)

func set_flip_h(flipped:bool):
	is_flipped = flipped
	body.set_flip_h(flipped)
	limbs.set_flip_h(flipped)

# Low Level Audio

func handle_walk_sounds():
	if (final_velocity.x != 0):
		if not sound_players.walk.looping:
			start_walk_sounds()
	elif (final_velocity.x == 0):
		stop_walk_sounds()

func start_walk_sounds():
	if not sound_players.walk.looping:
		sound_players.walk.start_sound_loop()

func stop_walk_sounds():
	if sound_players.walk.looping:
		sound_players.walk.stop_sound_loop()
