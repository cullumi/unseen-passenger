
extends Node2D

class_name Blinker

export (PackedScene) var default_ac_scene
export (PackedScene) var default_outer_ac_scene
export (PackedScene) var default_inner_ac_scene
export (Array, PackedScene) var ac_scenes = []
export (int) var angle_count = 5
export (Array, float) var open_angles = [-14.5, -7.25, 0, 6.9, 13.8]
export (Array, float) var close_angles = [0, 0, 0, 0, 0]
export (float, 0.01, 1) var squash_limit = 0.2
export (float, 0, 10) var blink_rate_max = 4
export (float, 0, 10) var blink_speed = 1

signal stage_changed
signal in_blink
signal mid_blink

var enabled setget set_enabled

export var angled_contents:Array = []
onready var squash = $Squash
var timer:Timer

enum ConLoc {
	INNER, OUTER, NA
}

var is_blinking = false
var blink = false

var level = 0
var stage = 0
var last_change = null

func _ready():
	create_angled_contents()
	create_timer()
	set_stage(1)

func _process(delta):
	if is_blinking:
		if not blink and timer.is_stopped():
			timer.start(rand_range(0, blink_rate_max))
	if blink:
		process_blink(delta)

# Enable / Disabled

func set_enabled(enable):
	for c in angled_contents:
		if c.has_method("set_enabled"):
			c.set_enabled(enable)
	squash.visible = enable

# Angled Content Creation



func create_angled_contents():
#	if default_ac_scene != null:
	ac_scenes.clear()
	Arrays.print_all(ac_scenes)
	Arrays.print_names(ac_scenes)
	for i in range(0, angle_count):
		var packed_scene = assign_ac_scene(i, ConLoc.INNER if (i>0 and i<angle_count-1) else ConLoc.OUTER)
		if packed_scene != null:
			var c = packed_scene.instance()
			add_child(c)
			angled_contents.append(c)
	Arrays.print_all(ac_scenes)
	Arrays.print_names(ac_scenes)

func assign_ac_scene(index=null, content_location=ConLoc.NA):
	if index!=null:
		if ac_scenes.size() > index and ac_scenes[index]!=null:
			return ac_scenes[index]
	match content_location:
		ConLoc.INNER:
			if default_inner_ac_scene!=null:
				return default_inner_ac_scene
		ConLoc.NA:
			pass
		ConLoc.OUTER:
			if default_outer_ac_scene!=null:
				return default_outer_ac_scene
	if default_ac_scene!=null:
		return default_ac_scene

# Starting and Stopping

func start_blinking():
	is_blinking = true

func stop_blinking():
	is_blinking = false

func start_blink():
	level = 0
	blink = true
	emit_signal("in_blink", true)

func stop_blink():
	level = 0
	blink = false
	emit_signal("in_blink", false)

# Blink Iteration

func process_blink(delta):
	var change = delta * blink_speed
	level = clamp(level + change, 0, 1)
	set_stage(level_to_stage(level))
	var bs = level - 0.5
	if bs >= 0 and bs < change:
		emit_signal("mid_blink", true)
	elif bs-change > 0 and bs-change-last_change <= 0:
		emit_signal("mid_blink", false)
	if level == 1:
		stop_blink()
	last_change = change

# Stage Processing

func set_stage(new_stage):
	stage = clamp(new_stage, 0, 1)
	for i in range(0, angled_contents.size()):
		angled_contents[i].rotation_degrees = lerp(close_angles[i], open_angles[i], stage)
	squash.scale.y = clamp(stage, squash_limit, 1)
	emit_signal("stage_changed", stage)
# warning-ignore:shadowed_variable
func level_to_stage(level): return abs((level-0.5) * 2)

# Blink Timer

func create_timer():
	timer = Timer.new()
	add_child(timer)
# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "_on_timer_timeout")

func _on_timer_timeout():
	start_blink()
	timer.stop()
