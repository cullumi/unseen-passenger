class_name Character

extends KinematicBody2D

export (float) var walk_speed = 120
export (float) var sneak_speed = 50
export (float) var sprint_speed = 300
export (float) var strafe_modifier = 0.75
export (float) var gravity = 200

onready var body = $Sprites/BaseS
onready var limbs:AnimatedSprite = $Sprites/LimbsAS

var move_dir:Vector2 = Vector2()
var look_dir:Vector2 = Vector2()
var speed:float  = walk_speed
var velocity:Vector2 = Vector2(0, gravity)
var is_flipped:bool = false
var lock_view:bool = false

var walk_audio_loop = null

const ANIM_WALK = "Walking"
const ANIM_RUN = "Running"
const ANIM_IDLE = "Idle"

# Inputs
var sprint = false
var view_changed = false
var is_focusing = false
var focus_zoom_scale = 0.75

# State

var state

func _ready() : state = PersistentState.new(self, CharFactory)
func set_sprint(sprint) : state.execute("toggle_sprint", sprint)
func toggle_view_lock() : state.execute("toggle_view_lock")

# High Level Movement

func sneak():
	speed = sneak_speed
	limbs.animation = ANIM_WALK

func walk():
	speed = walk_speed
	limbs.animation = ANIM_WALK

func run():
	speed = sprint_speed
	limbs.animation = ANIM_RUN

func idle():
	speed = 0
	limbs.animation = ANIM_IDLE

func is_strafing():
	return (is_flipped and move_dir.x > 0) or (not is_flipped and move_dir.x < 0)


# Low Level Movement

func construct_velocity():
	if (!is_on_floor()):
		velocity.y = +gravity
	else:
		velocity.y = 0
	velocity.x = move_dir.x * speed

func apply_velocity():
	move_and_slide(velocity, Vector2.UP)

func set_flip_h(flipped:bool):
	is_flipped = flipped
	body.set_flip_h(flipped)
	limbs.set_flip_h(flipped)
