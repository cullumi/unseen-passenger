extends PassState

class_name EscaptePassState

func _ready():
	passenger.move_toward_goal()
	passenger.set_sprint(true)
	set_flip(false)
