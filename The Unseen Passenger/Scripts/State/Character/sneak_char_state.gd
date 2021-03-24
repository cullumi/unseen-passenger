extends CharState

class_name SneakCharState

var strafe = false

# Called when the node enters the scene tree for the first time.
func _ready():
	character.walk()

func _process(_delta):
	if character.is_strafing():
		if not strafe:
			strafe = true
			character.strafe(character.sneak_speed/2)
	elif strafe:
		strafe = false
		character.walk()

func set_sneak(sneak:bool):
	print("Set sneak: ", sneak)
	character.sneak = sneak
	if not sneak: change_state("walk")

func set_sprint(sprint:bool):
	character.sprint = sprint
	if sprint: change_state("run")

func set_move_dir(move_dir):
	character.move_dir = move_dir
	if character.moving_horizontal():
		if character.sprint: 
			change_state("walk")
	else:
		change_state("idle")
