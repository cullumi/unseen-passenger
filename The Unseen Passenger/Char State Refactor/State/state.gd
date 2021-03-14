# state.gd

extends Node

class_name State

var change_state
var source
var persistent_state

func setup(change_state, source, persistent_state):
	self.change_state = change_state
	self.source = source
	self.persistent_state = persistent_state

func change_state(new_state_name):
	self.change_state.call_func(new_state_name)
