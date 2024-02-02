extends Collectable
class_name Clock

func destroy():
	$AnimationPlayer.play("destroy")
	active = false

func restore():
	$AnimationPlayer.play("restore")
	active = true
