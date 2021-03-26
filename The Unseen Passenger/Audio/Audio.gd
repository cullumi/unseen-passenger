

extends Node

# Autoload as "Audio"
# Intended purely for managing and storing audio files.

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

func _ready():
	FileLoader.load_files_to("res://audio/characters/walking", FileLoader.EXT.AUDIO, soundLists.char_walk)
	FileLoader.load_files_to("res://audio/doors/open", FileLoader.EXT.AUDIO, soundLists.door_open)
	FileLoader.load_files_to("res://audio/doors/close", FileLoader.EXT.AUDIO, soundLists.door_close)
	print(soundLists)
	
	if (music_loop.size() > 0):
#		print("Starting music loop...")
		music_player = AudioStreamPlayer.new()
		music_player.autoplay = auto_play_music
		music_player.stream = music_loop[0]
		add_child(music_player)
