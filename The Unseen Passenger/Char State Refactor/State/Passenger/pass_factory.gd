
extends StateFactory

class_name PassFactory

const name = "Passenger"

func _init():
	states = {
		"idle": IdlePassState,
		"flee": FleePassState,
		"sneak": SneakPassState, 
		"stalk": StalkPassState, 
		"escape": EscaptePassState, 
		"tele": TelePassState, 
	}
