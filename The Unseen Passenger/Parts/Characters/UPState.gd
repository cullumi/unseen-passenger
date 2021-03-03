extends Object

class_name UPState

var state_name:String
var state_func:FuncRef
var state_transitions:Dictionary
var state_tests:Dictionary

func _init(source:Object, state_name:String, state_transition_targets:Array=[]):
	self.state_name = state_name
	self.state_func = funcref(source, "state_" + state_name)
	for target in state_transition_targets:
		self.state_transitions[target] = funcref(source, "transition_" + state_name + "_" + target)
		self.state_tests[target] = funcref(source, "test_" + state_name + "_" + target)

func run_something(source, func_name):
	var function = funcref(source, func_name)
	function.call_func()

func perform(args=null):
	state_func.call_func()

func transition(target:String, args=null):
	if (state_transitions[target].is_valid()):
		state_transitions[target].call_func()
	else:
		print("Function not valid! Tried " + state_name + " --> " + target)

func test(target:String, args=null):
	return state_tests[target].call_func()

func test_transitions():
	for target in state_tests.keys():
		if test(target):
			return target
	return null

func auto_transition():
	var target = test_transitions()
	if target:
		transition(target)
		return target
	return null
