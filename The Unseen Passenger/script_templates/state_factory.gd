extends StateFactory

class_name NewFactory

const name = "New"

func _init()%VOID_RETURN%:
	states = {
		"idle": IdleNewState,
		# Other States Go Here
	}
