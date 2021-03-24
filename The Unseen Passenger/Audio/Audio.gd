

extends Node

# Autoload as "Audio"

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
#	load_audio_files_to("res://Audio/MusicLoop", music_loop)
	FileLoader.load_files_to("res://Audio/Characters/Walking", FileLoader.EXT.AUDIO, soundLists.char_walk)
	FileLoader.load_files_to("res://Audio/Doors/Open", FileLoader.EXT.AUDIO, soundLists.door_open)
	FileLoader.load_files_to("res://Audio/Doors/Close", FileLoader.EXT.AUDIO, soundLists.door_close)
	print(soundLists)
	
	if (music_loop.size() > 0):
#		print("Starting music loop...")
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
	if not sound_key in soundLists.keys():
		printerr("Incorrect Sound Key")
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
