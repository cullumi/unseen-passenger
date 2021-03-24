
extends State

class_name PlayState

onready var player = source

func flip_direction():
	player.set_scale_flip(player.is_flipped, player.cam_piv)

func interact():
	player.trigger()

func _add_interactable(interactable):
	player.add_interactable(interactable)

func _remove_interactable(interactable):
	player.remove_interactable(interactable)
