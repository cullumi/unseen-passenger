
extends Position2D

class_name FocusDetector

onready var blinker:Blinker = $Blinker
onready var coll_cone:CollisionCone2D = $CollisionCone2D
onready var invis_focus_cone = $Blinker/Squash/InvisFocusCone
onready var light_focus_cone = $Blinker/Squash/LightingFocusCone

signal body_entered
signal body_exited

var active = false

func _ready():
# warning-ignore:return_value_discarded
	blinker.connect("stage_changed", self, "_blinker_stage_changed")
	var vrs = []
	for i in range(0, blinker.angle_count):
		var content = blinker.angled_contents[i]
		if content is VisualRay2D:
			vrs.append(content)
	coll_cone.set_poly_count(vrs.size())
	for i in range(0, vrs.size()):
		vrs[i].connect("point_changed", coll_cone, "change_point", [i])

func set_active(activate:bool):
	self.active = activate
	invis_focus_cone.enabled = activate
	blinker.enabled = activate
	coll_cone.enabled = activate

func start_blinking(): blinker.start_blinking()
func stop_blinking(): blinker.stop_blinking()
func _blinker_stage_changed(stage):
	invis_focus_cone.color.a = stage
	light_focus_cone.color.a = stage

func _on_CollisionCone2D_body_entered(body):
	if (body.is_in_group("detectable")):
		body.detect() 
# warning-ignore:return_value_discarded
		blinker.connect("in_blink", body, "_detector_blinking")
# warning-ignore:return_value_discarded
		blinker.connect("mid_blink", body, "_detector_mid_blink")
	emit_signal("body_entered", body)

func _on_CollisionCone2D_body_exited(body):
	if (body.is_in_group("detectable")):
		body.stop_detecting()
		blinker.disconnect("in_blink", body, "_detector_blinking")
		blinker.disconnect("mid_blink", body, "_detector_mid_blink")
	emit_signal("body_exited", body)
