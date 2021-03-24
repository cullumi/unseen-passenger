extends PassState

class_name EscaptePassState

func _ready():
	passenger.move_toward_goal()
	passenger.start_sprinting()
	set_flip(false)
