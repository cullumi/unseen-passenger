

extends Node

# Autoload as "Effects"
# Intended only to spawn particle effects and the like.
# *Likely obsolete when using proper node-based development*

const DEFAULT_SOUND = "echo"
const NONE = null

var oneShots:Dictionary = {
	"echo":null,
}

func _ready():
	FileLoader.load_files_to("res://Effects/OneShots", FileLoader.EXT.SCENE, oneShots)
	print(oneShots)

func spawn_one_shot(key:String, source):
	var effect = oneShots[key].instance()
	source.add_child(effect)
	return effect
