extends Actor
class_name Collectable

#collide function for collectable class
func collide(actor:Actor, _floor:Floor)->int:
	if actor == null:
		return level.COLLISION_BEHAVIORS.NONE
	if actor is Player:
		return level.COLLISION_BEHAVIORS.GET_COLLECTED
	if actor is Wall:
		return level.COLLISION_BEHAVIORS.STOP
	return level.COLLISION_BEHAVIORS.PUSH
#function for what happens when this actor is collected, called by level
func get_collected():
	pass
