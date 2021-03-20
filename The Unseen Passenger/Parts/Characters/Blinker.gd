extends Node2D

class_name Blinker

export (float, -180, 180) var upper_open_angle = -14.5
export (float, -180, 180) var lower_open_angle = 13.8
export (float, -180, 180) var upper_close_angle = 0
export (float, -180, 180) var lower_close_angle = 0

onready var upper = $Upper
onready var lower = $Lower

var stage = 0

func set_stage(new_stage):
	stage = clamp(new_stage, 0, 1)
	
	upper.rotation_degrees = lerp(upper_close_angle, upper_open_angle, stage)
	lower.rotation_degrees = lerp(lower_close_angle, lower_open_angle, stage)
