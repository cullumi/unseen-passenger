extends Node

class_name PlayerInput

var player

# Last Event
var event:InputEvent = null

func _init(player):
	self.player = player

# Actions
func action_press(action) : return event.is_action_pressed(action)
func action_release(action) : return event.is_action_released(action)

func move(dir:Vector2, adj_weight=Vectors.PREFER_NEW) : player.set_move_dir(Vectors.adjust_dir_vector(player.move_dir, dir, adj_weight))
func look(dir:Vector2, adj_weight=Vectors.PREFER_NEW) : player.set_look_dir(Vectors.adjust_dir_vector(player.look_dir, dir, adj_weight))
func sprint(sprint) : player.set_sprint(sprint)
func toggle_view_lock() : player.toggle_view_lock()
func focus(focus) : player.set_focus(focus)

# Triggers
func _input(event):
	self.event = event
	# Moving
	if action_press("move_left") : move(Vector2.LEFT)	
	elif action_release("move_left") : move(Vector2.RIGHT, Vectors.MASK_NEW)
	elif action_press("move_right") : move(Vector2.RIGHT)
	elif action_release("move_right") : move(Vector2.LEFT, Vectors.MASK_NEW)
	# Looking
	elif action_press("look_left") : look(Vector2.LEFT)
	elif action_release("look_left") : look(Vector2.LEFT, Vectors.MASK_NEW)
	elif action_press("look_right") : look(Vector2.RIGHT)
	elif action_release("look_right") : look(Vector2.RIGHT, Vectors.MASK_NEW)
	elif action_press("look_up") : look(Vector2.UP)
	elif action_release("look_up") : look(Vector2.UP, Vectors.MASK_NEW)
	elif action_press("look_down") : look(Vector2.DOWN)
	elif action_release("look_down") : look(Vector2.DOWN, Vectors.MASK_NEW)
	# Other
	elif action_press("player_sprint") : sprint(true)
	elif action_release("player_sprint") : sprint(false)
	elif action_press("player_view_lock") : toggle_view_lock()
	# Focus
	elif action_press("player_focus") : focus(true)
	elif action_release("player_focus") : focus(false)
