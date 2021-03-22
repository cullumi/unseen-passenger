# state.gd

extends Node

class_name State

var ch_state
var source
var persistent_state

func setup(_change_state, _source, _persistent_state):
	self.ch_state = _change_state
	self.source = _source
	self.persistent_state = _persistent_state

func change_state(new_state_name):
	self.ch_state.call_func(new_state_name)
