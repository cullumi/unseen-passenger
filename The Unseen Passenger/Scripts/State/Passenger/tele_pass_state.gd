
extends PassState

class_name TelePassState

func _ready():
	print("Passenger Teleporting")
	var rand = randi()
	var mod_close = 4 if passenger.player_close() else 1
	var mod_near = 2 if passenger.player_near() else 1
	if not rand % clamp(5 - (params.recent_blinks * mod_close * mod_near), 1, 100):
		if not passenger.player_close():
			passenger.spooky_approach()
		else:
			passenger.leap_frog()
			change_state("escape")
	else:
		passenger.stop_moving()
		set_flip(false)

func _process(_delta):
	if passenger.is_detected() and not passenger.detector_mid_blink and not passenger.player_close():
		persistent_state.change_to_last_state()
	elif passenger.is_detected() and not passenger.detector_mid_blink and passenger.player_close():
		change_state("tele")

#func _set_mid_blink(mid_blink):
#	if passenger.is_detected() and mid_blink:
#		if passenger.player_close():
#			change_state("tele")
#		else:
#			persistent_state.change_to_last_state()
