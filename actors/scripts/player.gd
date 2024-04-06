extends Actor
class_name Player





var tween_to_position:Vector2 = position

func _ready():
	super._ready()
	texture = Globals.get_skin_texture()
	if get_parent() is Level:
		level.win.connect(_on_level_win)
	else:
		$SleepParticles.emitting = true
		$RewindParticles.emitting = true


func collide(actor:Actor, floor:Floor)->int:
	if actor is Wall or floor is Water:
		return level.COLLISION_BEHAVIORS.STOP
	if actor is Collectable:
		return level.COLLISION_BEHAVIORS.COLLECT
	return level.COLLISION_BEHAVIORS.PUSH

func move(new_position, is_reverse:bool = false):
	super.move(new_position)
	# if not actually moving, dont do anything
	if new_position == tween_to_position:
		return
	
	# calculate direction of movement
	var move_dir:Vector2 = (new_position - tween_to_position).normalized()
	if is_reverse:
		move_dir = move_dir*-1
	# change facing direction based on direction
	if move_dir == Vector2.LEFT:
		flip_h = true
	elif move_dir == Vector2.RIGHT:
		flip_h = false
	# update frame coords
	if frame_coords.x < hframes-1:
		frame_coords.x += 1
	else:
		frame_coords.x = 0
	tween_to_position = new_position

func _on_level_win():
	$AnimationPlayer.play("sleep")

func do_rewind_particles():
	$RewindParticles.emitting = true
