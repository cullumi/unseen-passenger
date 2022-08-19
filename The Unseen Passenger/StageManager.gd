extends Node2D

export (NodePath) var path_door_pass = "Train/TrainDoor1"
onready var passenger_door:Door = get_node(path_door_pass)
var reset_door_opener = false
var door_opener

func _ready():
	if door_opener:
		reset_door_opener = true
	door_opener = randomly_open_back_door()

func _unhandled_input(event):
	if (event.is_action_pressed("debug-restart")):
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()

func randomly_open_back_door():
	while true:
		yield(get_tree().create_timer(rand_range(5, 15)), "timeout")
		if (reset_door_opener):
			reset_door_opener = false
			return
		passenger_door.open()
