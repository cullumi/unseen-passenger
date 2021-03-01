extends AnimatedSprite

export (bool) var startOpen = false

signal state_changed

onready var collider : CollisionShape2D = $StaticBody2D/CollisionShape2D

var num_bodies = 0
var closable = true
var openable = true

var debug = false

func _ready():
	if (startOpen):
		instant_open()
	else:
		instant_close()

func open():
	if debug : print("Opening Door")
	animation = "Opening"
	playing = true
	collider.disabled = true

func close():
	if debug : print("Closing Door")
	animation = "Closing"
	playing = true
	collider.disabled = false

func instant_open():
	animation = "Opened"
	playing = true
	collider.disabled = true

func instant_close():
	animation = "Closed"
	playing = true
	collider.disabled = false

func _on_animation_finished():
	if debug : print("Animation Finished")
	playing = false

func _on_body_entered(body):
	if (!body is StaticBody2D):
		if debug : print("Non Static Body Entered Door...")
		closable = false
		num_bodies += 1
		emit_signal("state_changed")

func _on_body_exited(body):
	if (!body is StaticBody2D):
		num_bodies -= 1
		if (num_bodies <= 0):
			closable = true
			emit_signal("state_changed")
