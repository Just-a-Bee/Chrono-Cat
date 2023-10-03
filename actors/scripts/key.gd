extends Actor
class_name Key

func collide(actor:Actor)->int:
	if actor is Door:
		return level.COLLISION_BEHAVIORS.DESTROY
	if actor is Wall:
		return level.COLLISION_BEHAVIORS.STOP
	return level.COLLISION_BEHAVIORS.PUSH
