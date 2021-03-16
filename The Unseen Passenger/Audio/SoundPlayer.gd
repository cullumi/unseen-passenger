
extends Node2D

class_name SoundPlayer

var stream_player

var source
var offset = Vector2()

var max_distance = 1000
var attenuation = 1
var autoplay = false
var volume_db = 0

var sounds:Array
var looping:bool = false

# Initialization

func _ready():
	build()

func build():
	stream_player = AudioStreamPlayer2D.new()
	stream_player.max_distance = max_distance
	stream_player.attenuation = attenuation
	stream_player.autoplay = autoplay
	stream_player.volume_db = volume_db
	add_child(stream_player)

func rebuild(volume_db=self.volume_db, max_distance=self.max_distance, 
					attenuation=self.attenuation, autoplay=self.autoplay):
	self.max_distance = max_distance
	self.attenuation = attenuation
	self.autoplay = autoplay
	self.volume_db = volume_db
	stream_player.max_distance = max_distance
	stream_player.attenuation = attenuation
	stream_player.autoplay = autoplay
	stream_player.volume_db = volume_db

func set_offset(offset):
	self.offset = offset
	position = offset

func set_source(source):
	self.source = source

func set_sounds(sounds:Array):
	self.sounds = sounds

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
	stream_player.stream = sound
	stream_player.play()

func get_sound(idx:int):
	return sounds[idx]

# Asynchronous Stuff

func start_sound_loop(spacing=.75):
	print("Start sound loop.")
	if looping:
		yield(stop_sound_loop(), "completed")
	sound_loop(spacing)

func stop_sound_loop():
	looping = false
	yield(get_tree(), "idle_frame")

func sound_loop(spacing=.75):
	looping = true
	while looping:
		if not stream_player.playing:
			play_rand_sound()
			yield(get_tree().create_timer(spacing), "timeout")
