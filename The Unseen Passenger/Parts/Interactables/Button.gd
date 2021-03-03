extends Area2D

export (NodePath) var target_path

onready var target : Node2D = get_node(target_path)
onready var highlight = $ButtonHighlight
onready var light = $ButtonLight

var is_open : bool = false
var openable : bool = false
var closable : bool = false
var triggerable : bool = true
var automatic : bool = false
var highlighted : bool = false

func _ready():
	target.connect("state_changed", self, '_on_target_state_changed')
	fetch_target_state()
	if is_open:
		target.instant_open()
	else:
		target.instant_close()
	update_light()

func _input(event):
	if (highlighted):
		var player_interact = event.is_action_pressed("player_interact")
		if (player_interact):
			activate()

func activate():
	if (triggerable):
		if (is_open):
			close()
		else:
			open()

func open():
	if (openable):
		is_open = true
		target.open()
		update_light()

func close():
	if (closable):
		is_open = false
		target.close()
		update_light()

func set_can_trigger(can_trigger):
	triggerable = can_trigger
	update_light()

func update_light():
	if (is_open):
		if (closable):
			if (automatic):
				light.animation = "Automatic"
			else:
				light.animation = "CanClose"
		else:
			light.animation = "Locked"
	else:
		if (closable):
			if (automatic):
				light.animation = "Automatic"
			else:
				light.animation = "CanOpen"
		else:
			light.animation = "Locked"

func fetch_target_state():
	closable = target.closable
	openable = target.openable

func show_highlight():
	highlighted = true
	highlight.visible = true

func hide_highlight():
	highlighted = false
	highlight.visible = false

func _on_target_state_changed():
	fetch_target_state()
	update_light()

func _on_body_entered(body):
	if (body.is_in_group("player")):
		show_highlight()

func _on_body_exited(body):
	if (body.is_in_group("player")):
		hide_highlight()
