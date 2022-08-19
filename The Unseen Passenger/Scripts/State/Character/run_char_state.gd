extends CharState

class_name RunCharState

var strafe = false

# Called when the node enters the scene tree for the first time.
func _ready():
	character.run()

func _process(_delta):
	if character.is_strafing():
		if not strafe:
			strafe = true
			character.strafe(character.walk_speed)
	elif strafe:
		strafe = false
		character.run()

func _physics_process(_delta):
	if active:
		character.handle_walk_sounds()

func set_sprint(sprint:bool):
	character.sprint = sprint
	if not sprint: 
		if not character.sneak:
			change_state("walk")
		else:
			change_state("sneak")

func set_move_dir(move_dir):
	character.move_dir = move_dir
	if character.moving_horizontal():
		if not character.sprint:
			if not character.sneak:
				change_state("walk")
			else:
				change_state("sneak")
				change_state("sneak")
	else:
		change_state("idle")
