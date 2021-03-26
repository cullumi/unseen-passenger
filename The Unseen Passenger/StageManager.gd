extends Node2D

export (NodePath) var path_door_pass = "Train/TrainDoor1"
onready var passenger_door:Door = get_node(path_door_pass)

func _ready():
	randomly_open_back_door()

func randomly_open_back_door():
	while true:
		yield(get_tree().create_timer(rand_range(5, 15)), "timeout")
		passenger_door.open()
