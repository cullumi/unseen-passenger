
extends State

class_name PlayState

onready var player = source

func flip_direction():
	player.set_scale_flip(player.is_flipped, player.cam_piv)
