extends Actor
class_name Player

const SLEEP_1 = Vector2(0,1)


func _ready():
	super._ready()
	level.win.connect(_on_level_win)


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

func _on_level_win():
	await get_tree().create_timer(.3).timeout
	frame_coords = SLEEP_1
	await get_tree().create_timer(.5).timeout
	frame_coords.x += 1
