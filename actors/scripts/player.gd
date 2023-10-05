extends Actor
class_name Player

func collide(actor:Actor, floor:Floor)->int:
	print(floor)
	if actor is Wall or floor is Water:
		return level.COLLISION_BEHAVIORS.STOP
	if actor is Collectable:
		return level.COLLISION_BEHAVIORS.COLLECT
	return level.COLLISION_BEHAVIORS.PUSH
