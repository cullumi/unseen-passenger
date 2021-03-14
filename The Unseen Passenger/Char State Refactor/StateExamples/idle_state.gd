#idle_state.gd

extends State

class_name IdleState

func _ready():
	animated_sprite.play("Idle")

func _flip_direction():
	animated_sprite.flip_h = not animated_sprite.flip_h

func move_left():
	if animated_sprite.flip_h:
		change_state.call_func("run")
	else:
		_flip_direction()

func move_right():
	if not animated_sprite.flip_h:
		change_state.call_func("run")
	else:
		_flip_direction()
