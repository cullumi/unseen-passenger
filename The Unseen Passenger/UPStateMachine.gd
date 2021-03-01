extends Node

var up : UnseenPassenger

#Constants
var STALKING = "stalking"
var FLEEING = "fleeing"
var APPROACHING = "approaching"
var WAITING = "waiting"

# States
var state : String
var last_state : String
onready var states:Dictionary = {
	"stalking": UPState.new(self, "stalking", [FLEEING, WAITING, APPROACHING]),
	"fleeing": UPState.new(self, "fleeing", [WAITING, APPROACHING]),
	"waiting": UPState.new(self, "waiting", [STALKING, FLEEING, APPROACHING]),
	"approaching": UPState.new(self, "approaching", [STALKING]),
}

# Statuses
onready var status:Dictionary = {
	"confrontational":false,
	"rushing":false,
	"cautious":false,
	"afraid":false,
	
	"seen":false,
	"endangered":false,
	"safe":true,
	"detected":false,
	
	"cornered":false,
	"player_close":false,
	"player_near":false,
	"player_medium":false,
	"player_far":false,
}

func set_status(status:String, enable:bool):
	self.status[status] = enable

func set_state(state:String):
	self.last_state = self.state
	self.state = state

func start(state:String):
	set_state(state)
	perform()

func perform():
	states[self.state].perform()

func transition_to(target_state:String):
	states[self.state].transition(target_state)

func auto_transition():
	return states[self.state].auto_transition()

func print_state():
#	print("State: " + state)
	states[state].run_something(self, "alt_print_state")

func alt_print_state():
	print("State: " + state)

func print_status():
	var string = ""
	for key in status.keys():
		string = string + key + ":" + String(status[key]) + "  "
	print(string)


# Stalking

func state_stalking():
	up.dir.x = 1
	up.speed = up.sneak_speed
	up.set_flip_h(false)

# --> fleeing
func test_stalking_fleeing():
	return status.seen and status.player_close
func transition_stalking_fleeing():
	print("Fleeing!")
#	status.afraid = true
	start("fleeing")

# --> waiting
func test_stalking_waiting():
	return status.seen and status.player_near
func transition_stalking_waiting():
	UpStates.set_status("cautious", false)
	start("waiting")

# --> approaching
func test_stalking_approaching():
	return status.seen and status.player_far
func transition_stalking_approaching():
#	status.confrontational = true
	start("approaching")


# Fleeing

func state_fleeing():
	up.dir.x = -1
	up.speed = up.sprint_speed
	up.set_flip_h(true)

# --> waiting
func test_fleeing_waiting():
	return not status.seen and (status.cornered or status.player_far)
func transition_fleeing_waiting():
	up.start_caution_timer()
	start("waiting")

# --> approaching
func test_fleeing_approaching():
	return status.seen and status.cornered and status.player_close
func transition_fleeing_approaching():
#	status.confrontational = true
	start("approaching")


# Waiting

func state_waiting():
	up.speed = 0
	up.set_flip_h(false)

# --> stalking
func test_waiting_stalking():
	return not status.seen and not status.cautious
func transition_waiting_stalking():
	start("stalking")

# --> fleeing
func test_waiting_fleeing():
	return status.seen and status.player_close
func transition_waiting_fleeing():
	start("fleeing")

# --> approaching
func test_waiting_approaching():
	return status.seen and status.player_far and not status.cautious
func transition_waiting_approaching():
	start("approaching")


# Approaching

func state_approaching():
	up.dir.x = up.player_dir().x
	if (up.dir.x < 0):
		up.speed = up.back_speed
	elif (up.dir.x > 0):
		up.speed = up.forward_speed
	up.set_flip_h(false)

# --> stalking
func test_approaching_stalking():
	return status.seen and status.player_close
func transition_approaching_stalking():
	start("stalking")
