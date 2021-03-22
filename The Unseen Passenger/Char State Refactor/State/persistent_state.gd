# persistent_state.gd

extends Node

class_name PersistentState

var source
var factory_class
var start_state_name

var last_state_name:String
var state
var state_factory

func _init(_source, _factory_class, _start_state_name="idle"):
	self.source = _source
	self.factory_class = _factory_class
	self.start_state_name = _start_state_name

func _ready():
	state_factory = factory_class.new()
	change_state("idle")

func execute(method_name, varargs=null):
	if state.has_method(method_name): 
		var function = funcref(state, method_name)
		if varargs==null: 
			function.call_func()
		else: 
			function.call_func(varargs)

func change_to_last_state():
	change_state(last_state_name)

func change_state(new_state_name:String):
	if state != null:
		last_state_name = state.name
		state.queue_free()
	state = state_factory.get_state(new_state_name).new()
	state.setup(funcref(self, "change_state"), source, self)
	state.name = new_state_name
	add_child(state)
