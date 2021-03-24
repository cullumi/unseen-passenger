extends PlayState

class_name IdlePlayState

# Called when the node enters the scene tree for the first time.
func _ready():
	player.idle()

func _process(_delta):
	if player.is_sprinting() and player.is_strafing() and not player.looking_horizontal():
		player.flip_direction()

func set_focus(focus:bool):
	player.is_focusing = focus
	if focus: change_state("focus")

func toggle_view_lock():
	player.lock_view = not player.lock_view

func set_look_dir(look_dir):
	if not player.lock_view:
		player.look_dir = look_dir
		if player.is_flipped != player.looking_left():
			player.flip_direction()
