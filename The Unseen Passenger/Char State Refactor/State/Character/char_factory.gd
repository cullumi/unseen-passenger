extends StateFactory

class_name CharFactory

const name = "Character"

func _init():
	states = {
		"idle": IdleCharState,
		"walk": WalkCharState,
		"run": RunCharState
	}
