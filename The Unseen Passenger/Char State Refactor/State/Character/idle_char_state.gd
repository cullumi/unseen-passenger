extends CharState

class_name IdleCharState

onready var character:Character = source

# Called when the node enters the scene tree for the first time.
func _ready():
	character.speed = 0
	character.legs.play(character.ANIM_IDLE)

func _flip_direction():
	character.set_flip_h(not character.flipped)
