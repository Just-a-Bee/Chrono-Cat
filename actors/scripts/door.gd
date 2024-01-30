extends Wall
class_name Door

func destroy():
	hide()
	$GPUParticles2D.emitting = true
