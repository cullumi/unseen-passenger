extends Node

var player:Player

# Vector Weight Constants
const MASK_NEW = -2
const PREFER_OLD = -1
const NEUTRAL = 0
const PREFER_NEW = 1
const MASK_OLD = 2

# Last Event
var event = null

func _init(player:Player):
	self.player = player

# Actions
func action_press(action) : return event.is_action_pressed(action)
func action_release(action) : return event.is_action_released(action)

func move(dir:Vector2, adj_weight=PREFER_NEW) : player.move_dir = adjust_dir_vector(player.move_dir, dir, adj_weight)
func look(dir:Vector2, adj_weight=NEUTRAL) : player.look_dir = adjust_dir_vector(player.look_dir, dir, adj_weight)
func sprint(sprint) : player.set_sprint(sprint)
func toggle_view_lock() : player.toggle_view_lock()
func focus(focus) : player.set_focus(focus)

# Triggers
func _input(event):
	self.event = event
	# Moving
	if action_press("move_left") : move(Vector2.LEFT)	
	elif action_release("move_left") : move(Vector2.RIGHT, MASK_NEW)
	elif action_press("move_right") : move(Vector2.RIGHT)
	elif action_release("move_right") : move(Vector2.LEFT, MASK_NEW)
	# Looking
	elif action_press("look_left") : look(Vector2.LEFT)
	elif action_release("look_left") : look(Vector2.LEFT, MASK_OLD)
	elif action_press("look_right") : look(Vector2.RIGHT)
	elif action_release("look_right") : look(Vector2.RIGHT, MASK_OLD)
	elif action_press("look_up") : look(Vector2.UP)
	elif action_release("look_up") : look(Vector2.UP, MASK_OLD)
	elif action_press("look_down") : look(Vector2.DOWN)
	elif action_release("look_down") : look(Vector2.DOWN, MASK_OLD)
	# Other
	elif action_press("player_sprint") : sprint(true)
	elif action_release("player_sprint") : sprint(false)
	elif action_press("player_view_lock") : toggle_view_lock()
	# Focus
	elif action_press("player_focus") : focus(true)
	elif action_release("player_focus") : focus(false)

func adjust_dir_vector(dir1: Vector2, dir2 : Vector2, weight: int = 0, enable : bool = true):
	# Assumes both values of the Vector2 are either 1, 0, or -1.
	# weights: 2s mask values, 1s prioritize values, and 0s are neutral. 
	if (not enable):
		dir2 *= -1
	match weight:
		-2: dir2 *= dir1.normalized().abs()
		-1: dir1 *= 2
		1: dir2 *= 2
		2: dir1 *= dir2.normalized().abs()
	var dirSum = dir1 + dir2
	return dirSum.normalized()
