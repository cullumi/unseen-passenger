extends Particles2D

class_name ParticleEffect

func _ready():
	emitting = true
	yield(get_tree().create_timer(lifetime * amount), "timeout")
	queue_free()
