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

func execute(method_name, varargs):
	funcref(state, method_name).callfunc(varargs)

func change_state(new_state_name):
	if state != null:
		state.queue_free()
	state = state_factory.get_state(new_state_name).new()
	state.setup(funcref(self, "change_state"), source, self)
	state.name = "current_state"
	add_child(state)
