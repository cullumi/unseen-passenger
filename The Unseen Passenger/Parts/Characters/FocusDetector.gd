extends Position2D

export (float, 0, 1) var blink_level = 0
export (float, 0, 10) var blink_speed = 1
export (float, 0, 10) var blink_rate_max = 4
export (float, 0, 2) var blink_scale = 1

onready var focus_area = $Area2D
onready var focus_collider = $Area2D/CollisionPolygon2D
onready var focus_cone = $FocusCone
onready var focus_guide = $FocusGuide
onready var blink_timer:Timer = $BlinkDelayTimer

var is_blinking = false
var blink = false
var active = false
var last_change = null

signal blinking
signal mid_blink
signal body_entered
signal body_exited

func _process(delta):
	if is_blinking:
		if not blink and blink_timer.is_stopped():
			blink_timer.start(rand_range(0, blink_rate_max))
	if blink:
		process_blink(delta)

func set_active(active:bool):
	self.active = active
	focus_cone.enabled = active
	focus_guide.visible = active
	focus_collider.disabled = !active

func blink():
	blink_level = 0
	blink = true
	emit_signal("blinking", true)

func stop_blink():
	blink_level = 0
	blink = false
	emit_signal("blinking", false)

func start_blinking():
	is_blinking = true

func stop_blinking():
	is_blinking = false

func process_blink(delta):
	var change = delta * blink_speed
	blink_level = clamp(blink_level + change, 0, 1)
	display_blink(blink_level)
	var bs = blink_level - 0.5
	if bs >= 0 and bs < change:
		emit_signal("mid_blink", true)
	elif bs-change > 0 and bs-change-last_change <= 0:
		emit_signal("mid_blink", false)
	if blink_level == 1:
		stop_blink()
	last_change = change

func display_blink(level):
	var blink_stage = abs((level-0.5) * 2)
	focus_cone.scale.y = clamp(blink_stage * blink_scale, 0.2, blink_scale)
	focus_cone.color.a = blink_stage
	focus_guide.scale.y = blink_stage * blink_scale
	focus_area.scale.y = blink_stage * blink_scale

func _on_Area2D_body_entered(body):
	if (body.is_in_group("detectable")):
#		body.detected(true)
		body.detect() 
		connect("blinking", body, "_detector_blinking")
		connect("mid_blink", body, "_detector_mid_blink")
	emit_signal("body_entered", body)

func _on_Area2D_body_exited(body):
	if (body.is_in_group("detectable")):
#		body.detected(false)
		body.stop_detecting()
		disconnect("blinking", body, "_detector_blinking")
		disconnect("mid_blink", body, "_detector_mid_blink")
	emit_signal("body_exited", body)

func _on_BlinkDelayTimer_timeout():
	blink()
	blink_timer.stop()
