extends AudioStreamPlayer2D

class_name SoundPlayer2D

# This node is mainly intended to extend certain looping functionality of
# AudioStreamPlayer2D.  It supports the following:
# - Randomized Sound Effects (based on a given list)
# - Spaced Sound Effect Looping
# - Start and End Signals

export (String) var sound_key = "char_walk"

signal sound_started
signal sound_ended

var sounds:Array
var looping:bool = false

# Initialization

func _ready():
	sounds = Audio.soundLists[sound_key]
	connect("finished", self, "_sound_ended")

# The Basics

func play_rand_sound():
	randomize()
	var rand_idx = randi() % sounds.size()
	var sound = sounds[rand_idx]
	play_sound(sound)

func play_sound_idx(idx:int):
	var sound = sounds[idx]
	play_sound(sound)

func play_sound(sound:AudioStream):
	print("Playing Sound")
	stream = sound
	play()
	emit_signal("sound_started")

func get_sound(idx:int):
	return sounds[idx]

# Asynchronous Stuff

func start_sound_loop(spacing=.75):
	if looping:
		yield(stop_sound_loop(), "completed")
	sound_loop(spacing)

func stop_sound_loop():
	looping = false
#	yield(get_tree(), "idle_frame")

func sound_loop(spacing=.75):
	looping = true
	while looping:
		if not playing:
			play_rand_sound()
			yield(get_tree().create_timer(spacing), "timeout")
		else:
			yield(get_tree(), "idle_frame")

func _sound_ended():
	print("Sound Ended")
	stop()
	emit_signal("sound_ended")
