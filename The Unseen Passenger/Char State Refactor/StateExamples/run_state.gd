#run_state.gd

extends State

class_name RunState

var move_speed = Vector2(180, 0)
var min_move_speed = 0.005
var friction = 0.32

func _ready():
	animated_sprite.play("run")
	if animated_sprite.flip_h:
		move_speed.x *= -1
	persistent_state.velocity += move_speed

func _physics_process(_delta):
	if abs(persistent_state.velocity.x) < min_move_speed:
		change_state.call_func("idle")
	persistent_state.velocity.x *= friction

func move_left():
	if animated_sprite.flip_h:
		persistent_state.velocity += move_speed
	else:
		change_state.call_func("idle")

func move_right():
	if not animated_sprite.flip_h:
		persistent_state.velocity += move_speed
	else:
		change_state.call_func("idle")
