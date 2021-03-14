
extends State

class_name CharState

func _physics_process(delta):
	source.construct_velocity()
	source.apply_velocity()
