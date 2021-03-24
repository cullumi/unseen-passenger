extends StateFactory

class_name PlayFactory

const name = "Player"

func _init():
	states = {
		"idle": IdlePlayState,
		"focus": FocusPlayState,
	}
