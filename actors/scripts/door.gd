extends Wall
class_name Door

func destroy():
	$GPUParticles2D.restart()
	$AnimationPlayer.play("destroy")
	active = false

func restore():
	$AnimationPlayer.play("restore")
	active = true
