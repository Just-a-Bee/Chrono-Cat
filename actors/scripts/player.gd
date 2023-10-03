extends Actor
class_name Player

func collide(actor:Actor)->int:
	if actor is Collectable:
		return level.COLLISION_BEHAVIORS.COLLECT
	if actor is Wall:
		return level.COLLISION_BEHAVIORS.STOP
	return level.COLLISION_BEHAVIORS.PUSH
