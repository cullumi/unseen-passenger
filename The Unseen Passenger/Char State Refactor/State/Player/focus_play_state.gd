extends PlayState

class_name FocusPlayState

# Called when the node enters the scene tree for the first time.
func _ready():
	player.focus()

func _process(_delta):
	player.point_focus(player.get_global_mouse_position())

func set_focus(focus):
	player.is_focusing = focus
	if not focus: change_state("idle")
