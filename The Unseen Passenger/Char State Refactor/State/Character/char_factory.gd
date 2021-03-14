extends StateFactory

class_name CharFactory

func _init():
	states = {
		"idle": IdleCharState,
		"run": RunCharState
	}
