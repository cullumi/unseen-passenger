
extends State

class_name CharState

onready var character = source

func _physics_process(_delta):
	character.construct_velocity()
	character.apply_velocity()

func flip_direction():
	character.set_flip_h(not character.is_flipped)

func set_sprint(sprint):
	character.sprint = sprint
