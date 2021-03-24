extends PassState

class_name SneakPassState

func _ready():
	print("Passenger Sneaking")
	passenger.move_toward_goal()
	passenger.start_sneaking()
	set_flip(false)
	reset_param("recent_blinks")

func _process(_delta):
	if passenger.is_detected() and passenger.player_close():
		change_state("flee")
	elif passenger.is_detected() and passenger.player_near():
		set_status("cautious", false)
		change_state("idle")
	elif passenger.is_detected() and passenger.player_far():
		change_state("stalk")

