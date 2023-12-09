extends Actor
class_name Player

func collide(actor:Actor, floor:Floor)->int:
	if actor is Wall or floor is Water:
		return level.COLLISION_BEHAVIORS.STOP
	if actor is Collectable:
		return level.COLLISION_BEHAVIORS.COLLECT
	return level.COLLISION_BEHAVIORS.PUSH

func move(new_position):
	super.move(new_position)
	var move_dir:Vector2 = (new_position - position).normalized()
	if move_dir == Vector2.LEFT:
		flip_h = true
	elif move_dir == Vector2.RIGHT:
		flip_h = false
	if frame_coords.x < hframes-1:
		frame_coords.x += 1
	else:
		frame_coords.x = 0
