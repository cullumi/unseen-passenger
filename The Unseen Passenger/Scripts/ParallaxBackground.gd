extends ParallaxBackground

onready var pb_sky = $Sky
onready var pb_clouds = $Clouds
onready var pb_mountains = $Mountains
onready var pb_hills = $Hills
onready var pb_tracks = $Tracks

func _physics_process(delta):
	pb_sky.motion_offset.x -= delta * 31.25
	pb_clouds.motion_offset.x -= delta * 62.5
	pb_mountains.motion_offset.x -= delta * 125
	pb_hills.motion_offset.x -= delta * 250
	pb_tracks.motion_offset.x -= delta * (250+125)
