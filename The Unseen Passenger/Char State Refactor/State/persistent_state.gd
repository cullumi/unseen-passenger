# persistent_state.gd

extends Node

class_name PersistentState

var source
var factory_class

var state
var state_factory

func _init(source, factory_class):
	self.source = source
	self.factory_class = factory_class

func _ready():
	state_factory = factory_class.new()
	change_state("idle")

func execute(method_name, varargs=null):
	if state.has_method(method_name): 
#		funcref(state, method_name).call_func(varargs)
		print(state_factory.name, " Executing: " + method_name + " on ", state.name, " with ", varargs)
		var function = funcref(state, method_name)
		function.call_func() if varargs==null else function.call_func(varargs)

func change_state(new_state_name:String):
	if state != null:
		state.queue_free()
	state = state_factory.get_state(new_state_name).new()
	state.setup(funcref(self, "change_state"), source, self)
	state.name = "[" + new_state_name + "]"
	add_child(state)
