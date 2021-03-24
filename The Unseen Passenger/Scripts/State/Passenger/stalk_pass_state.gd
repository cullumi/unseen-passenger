extends PassState

class_name StalkPassState

func _ready():
	print("Passenger Stalking")
	set_flip(false)

func _process(_delta):
	passenger.stalk()
	if not passenger.is_detected() or passenger.player_distant():
		status.confrontational = false
		change_state("sneak")
	elif passenger.is_detected() and passenger.player_close() and not status.confrontational:
		change_state("flee")
#	elif passenger.is_detected() and passenger.detector_mid_blink:
#		change_state("tele")

func _set_mid_blink(mid_blink):
	passenger.detector_mid_blink = mid_blink
	if mid_blink: #passenger.is_detected() and :
		change_state("tele")
