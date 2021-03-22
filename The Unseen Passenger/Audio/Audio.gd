extends Node

var auto_play_music = false
var music_loop = []
var music_player : AudioStreamPlayer
var sp_pool = []

const decibels = 0

const CHAR_WALK = "char_walk"
const DOOR_OPEN = "door_open"
const DOOR_CLOSE = "door_close"

var soundLists:Dictionary = {
	"char_walk":[],
	"door_open":[],
	"door_close":[],
}
var visualSoundLists:Dictionary = {
	"default":[],
	"char_walk":[],
	"door_open":[],
	"door_close":[],
}

func _ready():
#	music_loop.append(load("res://Audio/MusicLoop/347848__foolboymedia__new-york-jazz-loop.wav"))
#	capture_sounds.append(load("res://Audio/PieceCapture/chipLay3.ogg"))
#	move_sounds.append(load("res://Audio/PieceMove/chipLay1.ogg"))
#	load_audio_files_to("res://Audio/PieceMove", move_sounds)
#	load_audio_files_to("res://Audio/MusicLoop", music_loop)
	load_audio_files_to("res://Audio/Characters/Walking", soundLists.char_walk)
	load_audio_files_to("res://Audio/Doors/Open", soundLists.door_open)
	load_audio_files_to("res://Audio/Doors/Close", soundLists.door_close)
	print(soundLists)
	
	if (music_loop.size() > 0):
		print("Starting music loop...")
		music_player = AudioStreamPlayer.new()
		music_player.autoplay = auto_play_music
		music_player.stream = music_loop[0]
		add_child(music_player)
	if (sounds_present()):
		for _i in range(0, 2):
			sp_pool.push_back(new_sound_player())

#For interacting with the sound player pool

func unassign_sound_player(sound_player):
	sound_player.get_parent().remove_child(sound_player)
	sp_pool.push_back(sound_player)

func new_sound_player():
	var sound_player = SoundPlayer.new()
	return sound_player

func assign_sound_player(sound_key:String, source=self, offset=Vector2()):
	var sound_player = retrieve_sound_player()
	source.add_child(sound_player)
	sound_player.set_source(source)
	sound_player.set_offset(offset)
	sound_player.set_sounds(soundLists[sound_key])
	return sound_player

func retrieve_sound_player():
	if (sp_pool.size()):
		return sp_pool.pop_front()
	else:
		return new_sound_player()

# For use in file loading

func sounds_present():
	for key in soundLists.keys():
		if not soundLists[key].size():
			return false
	return true

func load_audio_files_to(str_dir : String, file_list = null):
	if (file_list == null):
		file_list = []
	var dir : Directory = Directory.new()
# warning-ignore:return_value_discarded
	dir.open(str_dir)
# warning-ignore:return_value_discarded
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and not dir.current_is_dir():
			if (file.ends_with(".ogg") or file.ends_with(".wav")):
				file_list.append(load(dir.get_current_dir() + "/" + file))
	dir.list_dir_end()
	return file_list

#func start_sound_loop(sounds_key, source=null, location=Vector2()):
##	print(source.name + " started sound loop.")
#	var sound_player = assign_sound_player(source, location)
#	loops[sound_player] = true
#	sound_loop(soundLists[sounds_key], sound_player)
#	return sound_player
#
#func sound_loop(sounds, sound_player, spacing=.75):
#	var ran_once = false
#	while true:
#		if loops[sound_player]:
#			if not sound_player.playing:
#				play_rand_sound(sounds, sound_player)
#				yield(get_tree().create_timer(spacing), "timeout")
#				if not loops[sound_player]:
#					clear_loop(sound_player)
#					return
#			yield(get_tree(), "idle_frame")
#		else:
#			clear_loop(sound_player)
#			return

#func clear_loop(sound_player):
#	loops.erase(sound_player)
#	unassign_sound_player(sound_player)

#func stop_sound_loop(sound_loop):
##	print(sound_loop.get_parent().name + " tried to stop sound loop.")
#	loops[sound_loop] = false

#func play_rand_sound(sounds:Array, sound_player):
#	randomize()
#	var rand_idx = randi() % sounds.size()
#	var sound = sounds[rand_idx]
#	play_sound(sound, sound_player)

#func play_sound(sound:AudioStream, sound_player):
##	print("Playing sound...")
#	sound_player.stream = sound
#	sound_player.play()
