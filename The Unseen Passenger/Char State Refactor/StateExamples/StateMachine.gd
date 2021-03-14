class_name StateMachine
extends Object


# States
var state : String
var last_state : String
var states : Dictionary


# Statuses
var status : Dictionary


# Params
var params : Dictionary


# Starters
func start(state:String):
	print("Next is: " + state)
	set_state(state)
	perform()

func start_last():
	print("Last was " + last_state)
	set_state(self.last_state)
	perform()

func perform():
	states[self.state].perform()


# Transitioners
func transition_to(target_state:String):
	states[self.state].transition(target_state)

func auto_transition():
	return states[self.state].auto_transition()


# Printers
func print_state():
	states[state].run_something(self, "alt_print_state")

func alt_print_state():
	print("State: " + state)

func print_status():
	var string = ""
	for key in status.keys():
		string = string + key + ":" + String(status[key]) + "  "
	print(string)


# Setters
func set_status(status:String, enable:bool):
	self.status[status] = enable

func set_param(param:String, value:int):
	self.params[param] = value

func inc_param(param:String):
	self.params[param] += 1

func reset_param(param:String):
	self.params[param] = 0

func set_state(state:String):
	self.last_state = self.state
	self.state = state
