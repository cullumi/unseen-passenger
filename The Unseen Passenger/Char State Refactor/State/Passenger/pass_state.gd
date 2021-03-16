extends State

class_name PassState

onready var passenger = source
onready var status = passenger.status
onready var params = passenger.params

func flip_direction():
	pass

func _set_mid_blink(mid_blink):
	passenger.detector_mid_blink = mid_blink

func _add_interactable(interactable):
	if not passenger.interactables.has(interactable):
		passenger.add_interactable(interactable)

func _remove_interactable(interactable):
	if passenger.interactables.has(interactable):
		passenger.remove_interactable(interactable)

# Helpers
func set_status(status:String, enable:bool):
	self.status[status] = enable

func set_param(param:String, value:int):
	self.params[param] = value

func inc_param(param:String):
	self.params[param] += 1

func reset_param(param:String):
	self.params[param] = 0

func set_flip(flip:bool):
	if passenger.is_flipped != flip:
		passenger.flip_direction()
