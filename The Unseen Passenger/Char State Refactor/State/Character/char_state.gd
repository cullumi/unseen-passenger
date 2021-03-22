
extends State

class_name CharState

onready var character = source

func _physics_process(_delta):
	character.construct_velocity()
	character.apply_velocity()
	
	if (character.final_velocity.x != 0 and not character.walk_sound_player.looping):
		character.walk_sound_player.start_sound_loop()
	elif (character.final_velocity.x == 0 and character.walk_sound_player.looping):
		character.walk_sound_player.stop_sound_loop()

func flip_direction():
	character.set_flip_h(not character.is_flipped)

func set_sprint(sprint):
	character.sprint = sprint
