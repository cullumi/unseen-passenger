extends AnimatedSprite

export (bool) var startOpen = false

signal state_changed

onready var collider : CollisionShape2D = $StaticBody2D/CollisionShape2D
onready var light_occluder : LightOccluder2D = $LightOccluder2D
onready var sound_location : Position2D = $SoundLocation

var num_bodies = 0
var closable = true
var openable = true

var open_sound_player = null
var close_sound_player = null

var debug = false

func _ready():
	open_sound_player = Audio.assign_sound_player(Audio.DOOR_OPEN, sound_location)
	open_sound_player = Audio.assign_sound_player(Audio.DOOR_CLOSE, sound_location)
	if (startOpen):
		instant_open()
	else:
		instant_close()

func open():
	if debug : print("Opening Door")
	animation = "Opening"
	playing = true
	collider.disabled = true
	light_occluder.visible = false
	if open_sound_player:
		open_sound_player.play_rand_sound()

func close():
	if debug : print("Closing Door")
	animation = "Closing"
	playing = true
	collider.disabled = false
	light_occluder.visible = true
	if close_sound_player:
		close_sound_player.play_rand_sound()

func instant_open():
	animation = "Opened"
	playing = true
	collider.disabled = true
	light_occluder.visible = false

func instant_close():
	animation = "Closed"
	playing = true
	collider.disabled = false
	light_occluder.visible = true

func _on_animation_finished():
	if debug : print("Animation Finished")
	playing = false

func _on_body_entered(body):
	if (!body is StaticBody2D):
		if debug : print("Non Static Body Entered Door...")
		closable = false
		num_bodies += 1
		emit_signal("state_changed")

func _on_body_exited(body):
	if (!body is StaticBody2D):
		num_bodies -= 1
		if (num_bodies <= 0):
			closable = true
			emit_signal("state_changed")
