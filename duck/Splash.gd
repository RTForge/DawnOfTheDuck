extends Spatial

onready var particle = $SplashParticle
onready var audio = $SplashAudio

func run_at(var pos : Vector3):
	global_transform.origin = pos
	particle.restart()
	particle.emitting = true
	audio.pitch_scale = 1.0 + randf() * 0.1
	audio.play()
