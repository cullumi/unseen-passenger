# state.gd

extends Node

class_name State

var change_state
var source
var persistent_state

func setup(change_state, source, persistant_state):
	self.change_state = change_state
	self.source = source
	self.persistant_state = persistant_state
