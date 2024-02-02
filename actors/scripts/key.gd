extends Actor
class_name Key

func collide(actor:Actor, _floor:Floor)->int:
	if actor == null:
		return level.COLLISION_BEHAVIORS.NONE
	if actor is Door:
		return level.COLLISION_BEHAVIORS.DESTROY
	if actor is Wall:
		return level.COLLISION_BEHAVIORS.STOP
	return level.COLLISION_BEHAVIORS.PUSH

func destroy():
	$AnimationPlayer.play("destroy")
	active = false
func restore():
	$AnimationPlayer.play("restore")
