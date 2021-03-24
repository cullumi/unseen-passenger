extends PassState

class_name FleePassState

const OPEN = true
const CLOSE = false

func _ready():
	print("Passenger Fleeing")
	passenger.move_away_from_player()
	passenger.start_sprinting()
	set_flip(true)

func _process(_delta):
	if not passenger.is_detected() or passenger.player_distant() or passenger.is_cornered():
		change_state("idle")
	elif passenger.is_detected() and passenger.is_cornered() and passenger.player_close():
		change_state("stalk")

func _physics_process(_delta):
	if passenger.can_interact():
		passenger.trigger_door(OPEN)

func _remove_interactable(interactable):
	if passenger.interactables.has(interactable):
		if interactable.is_in_group("door"):
			interactable.trigger(passenger, CLOSE, true)
		passenger.remove_interactable(interactable)
