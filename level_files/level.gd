extends TileMap
class_name Level

signal win

#dictionary that contains all actors and their level positions
var actor_dictionary:Dictionary

enum COLLISION_BEHAVIORS
{
	PUSH = 0,
	STOP = 1,
	DESTROY = 2,
	COLLECT = 3
}

func _ready():
	#index all actors
	for actor in get_children():
		actor_dictionary[local_to_map(actor.position)] = actor
	win.connect(GameState.win_level)

#function to try to move an actor, returns true if successfully moved
func try_move(actor:Actor, direction:Vector2i)->void:
	var from_position = actor_dictionary.find_key(actor)
	var to_position = from_position + direction
	
	# if to_position is occupied, try to push
	if actor_dictionary.has(to_position):
		
		var target_position:Vector2i = to_position # position we are checking for actors
		var push_array:Array[Actor] = [actor]
		
		handle_collision(target_position, push_array, direction)
		
		# iterate through push array in reverse, moving each actor individually
		push_array.reverse()
		for push_actor in push_array:
			move_actor(push_actor, direction)
	else:
		move_actor(actor, direction)

# function to handle when player collides with another actor
func handle_collision(target_position, push_array, direction):
	# iterate through positions until one is unoccupied, or we hit a wall and cant move
	while(actor_dictionary.has(target_position)):
		var to_actor = actor_dictionary[target_position]
		
		var collision_behavior:int = push_array[-1].collide(to_actor)
		
		if collision_behavior == COLLISION_BEHAVIORS.PUSH: # adds that actor to push array
			push_array.append(to_actor)
			target_position += direction
		elif collision_behavior == COLLISION_BEHAVIORS.STOP: # returns because move cannot go through
			push_array.clear()
			return
		elif collision_behavior == COLLISION_BEHAVIORS.DESTROY: # removes previous actor from push array, both are destroyed
			destroy_actor(to_actor)
			destroy_actor(push_array[-1])
			push_array.pop_at(-1)
		elif collision_behavior == COLLISION_BEHAVIORS.COLLECT: # actor is destroyed, a behavior happens based on actor
			collect_actor(to_actor)

func collect_actor(actor:Actor):
	if actor.is_objective:
		win.emit()
#	if actor.is_clock:
#		print("clock collected")
	destroy_actor(actor)

#function to move an actor, pass in actor to move and direction to move it
func move_actor(actor:Actor, direction:Vector2i):
	var from_position = actor_dictionary.find_key(actor) # gets position actor is going from
	var to_position = from_position + direction # gets position actor is going to
	actor_dictionary[to_position] = actor_dictionary[from_position] # put actor in new position
	actor_dictionary.erase(from_position) # remove actor from old position
	actor_dictionary[to_position].move(map_to_local(to_position)) # visually move the actor's scene
#function to destroy an actor
func destroy_actor(actor:Actor):
	var actor_key = actor_dictionary.find_key(actor)
	actor_dictionary.erase(actor_key)
	remove_child(actor)
