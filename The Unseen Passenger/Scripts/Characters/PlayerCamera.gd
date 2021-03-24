extends Position2D

export (NodePath) var target_path = "../Player/CamPivot/CamTarget"
onready var target = get_node(target_path)
onready var camera = $Camera2D
onready var tween = $Tween

onready var initial_zoom = camera.zoom 
var last_pos
var pos_weight = 0

func _process(_delta):
	position.x = target.global_position.x

func smooth_zoom(zoom=null):
	if (zoom == null):
		zoom = initial_zoom
	tween.interpolate_property(camera, "zoom",
		camera.zoom, initial_zoom * zoom, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
