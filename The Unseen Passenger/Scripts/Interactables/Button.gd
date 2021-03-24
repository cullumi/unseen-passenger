extends Area2D

export (NodePath) var target_path
export (Dictionary) var valid_trigger_groups = {
	"open":["director"],
	"close":["director"],
}

onready var target : Node2D = get_node(target_path)
onready var highlight = $ButtonHighlight
onready var light = $ButtonLight

# Trigger Options
const T_OPEN = true
const T_CLOSE = false
const T_TOGGLE = null
const TS_OPEN = "open"
const TS_CLOSE = "close"
const TS_TOGGLE = "toggle"

# Light Options
const L_Automatic = "Automatic"
const L_UNLOCKED = "Unlocked"
const L_LOCKED = "Locked"
const L_OPEN = "Open"
const L_BLOCKED = "Blocked"

var is_open : bool = false
var openable : bool = false
var closable : bool = false
var triggerable : bool = true
var automatic : bool = false
var highlighted : bool = false

func _ready():
# warning-ignore:return_value_discarded
	target.connect("state_changed", self, '_on_target_state_changed')
	fetch_target_state()
	if is_open:
		target.instant_open()
	else:
		target.instant_close()
	update_light()

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
	if is_open:
		if group_is_valid("player", TS_CLOSE):
			if closable:
				light.play(L_OPEN)
			else:
				light.play(L_BLOCKED)
		else:
			light.play(L_LOCKED)
	else:
		if group_is_valid("player", TS_OPEN):
			if openable:
				light.play(L_UNLOCKED)
			else:
				light.play(L_BLOCKED)
		else:
			light.play(L_LOCKED)

func fetch_target_state():
	closable = target.closable
	openable = target.openable

func show_highlight():
	highlighted = true
	highlight.visible = true

func hide_highlight():
	highlighted = false
	highlight.visible = false

func trigger(interactor, open=null, trigger_when_possible=false, use_delay=false, delay=1.0):
	print("Button Triggered: ", interactor.name, ", ", "Open" if open else ("Toggle" if open==null else "Close"))
	if (use_delay):
		yield(get_tree().create_timer(delay), "timeout")
	if has_valid_group(interactor, open):
		while (true):
			if closable != open or openable == open:
				if open==T_TOGGLE or open != is_open:
					activate()
				return
			if trigger_when_possible:
				yield(get_tree(), "idle_frame")
			else:
				return

func group_is_valid(interactor_group:String, validity_key:String):
	return valid_trigger_groups[validity_key].has(interactor_group)

func has_valid_group(interactor, validity_key="trigger"):
	if not validity_key is String: validity_key = validity_group(validity_key)
	for group in valid_trigger_groups[validity_key]:
		if interactor.is_in_group(group): 
			return true
	return false

func validity_group(validity_key=null):
	match validity_key:
		T_OPEN: return TS_OPEN
		T_CLOSE: return TS_CLOSE
		T_TOGGLE: return TS_CLOSE if is_open else TS_OPEN

func _on_target_state_changed():
	fetch_target_state()
	update_light()

func _on_body_entered(body):
	if (body.is_in_group("player")):
		show_highlight()

func _on_body_exited(body):
	if (body.is_in_group("player")):
		hide_highlight()
