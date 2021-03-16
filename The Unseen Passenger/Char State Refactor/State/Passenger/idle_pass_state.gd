extends PassState

class_name IdlePassState

func _ready():
	print("Passenger Waiting")
	passenger.stop_moving()
	set_flip(false)

func _process(_delta):
	if not passenger.is_detected() and not passenger.is_cautious():
		change_state("sneak")
	elif passenger.is_detected() and (passenger.player_close() or (passenger.is_cautious() and passenger.player_distant())):
		change_state("flee")
	elif passenger.is_detected() and passenger.player_distant() and not passenger.is_cautious():
		change_state("stalk")
#	elif passenger.is_detected() and passenger.detector_mid_blink:
#		change_state("tele")

func _set_mid_blink(mid_blink):
	passenger.detector_mid_blink = mid_blink
	if mid_blink: #passenger.is_detected() and mid_blink:
		change_state("tele")
