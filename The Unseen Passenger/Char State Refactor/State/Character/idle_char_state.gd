extends CharState

class_name IdleCharState

# Called when the node enters the scene tree for the first time.
func _ready():
	character.wait()

func set_move_dir(move_dir):
	character.move_dir = move_dir
	if character.moving_horizontal():
		if character.sprint:
			change_state("run")
		else:
			change_state("walk")
