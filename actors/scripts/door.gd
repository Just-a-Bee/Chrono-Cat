extends Wall
class_name Door

func destroy():
	$AnimationPlayer.play("destroy")
	active = false

func restore():
	$AnimationPlayer.play("restore")
	active = true
