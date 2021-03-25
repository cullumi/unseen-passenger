extends Particles2D

class_name ParticleEffect

func emit():
	print("Emitting")
	restart()
	emitting = true
