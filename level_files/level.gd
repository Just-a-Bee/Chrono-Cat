extends TileMap
class_name Level

signal win

# dictionary that contains all actors and their level positions
# keys = positions, values = actor at position
var actor_dictionary:Dictionary
@export var player:Node2D

var cursor_packed = preload("res://rewind_cursor.tscn")
var rewind_cursor
var rewinding
# dictionary that stores each actor and a list of its rewind positions
# keys = actor, values = array of rewind positions
var rewind_dictionary:Dictionary

# stores a copy of game state every turn that can be reverted to
# state is composed of [actor_dictionary, rewind_dictionary]
var undo_array:Array[Array]
var current_state:Array[Dictionary] = [actor_dictionary, rewind_dictionary]

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
		rewind_dictionary[actor] = []
	win.connect(GameState.win_level)

# function to handle all gameplay input
func _input(event):
	var direction:Vector2i = get_direction(event)
	if direction != Vector2i.ZERO:
		move_input(direction)
	elif event.is_action_pressed("undo"):
		undo()
	elif event.is_action_pressed("rewind"):
		rewind_input()

# function to return input direction of move event, if there isnt one it returns Vector2i.ZERO
func get_direction(event)->Vector2i:
	if event.is_action_pressed("up"):
		return Vector2i.UP
	if event.is_action_pressed("left"):
		return Vector2i.LEFT
	if event.is_action_pressed("right"):
		return Vector2i.RIGHT
	if event.is_action_pressed("down"):
		return Vector2i.DOWN
	return Vector2i.ZERO
# function to handle move direction
func move_input(direction):
	if not rewinding:
		make_move(player, direction)
	else:
		move_cursor(direction)
# actor and movement functions
#function to try to move an actor, returns true if successfully moved
func make_move(actor:Actor, direction:Vector2i)->void:
	var state:Array[Dictionary] = current_state.duplicate(true) # make a copy of the current state to save to undo arr
	var actor_moved:bool = false # store if an actor has been moved
	var from_position:Vector2i = actor_dictionary.find_key(actor)
	var to_position:Vector2i = from_position + direction
	
	# if to_position is occupied, try to push
	if actor_dictionary.has(to_position):
		
		var target_position:Vector2i = to_position # position we are checking for actors
		var push_array:Array[Actor] = [actor]
		
		handle_collision(target_position, push_array, direction)
		
		# iterate through push array in reverse, moving each actor individually
		push_array.reverse()
		for push_actor in push_array:
			move_actor(push_actor, direction)
			actor_moved = true
	else:
		move_actor(actor, direction)
		actor_moved = true
	if actor_moved:
		undo_array.append(state) # if a move was made, append the previous state to the undo array
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
# function to move an actor, pass in actor to move and direction to move it
func move_actor(actor:Actor, direction:Vector2i):
	var from_position = actor_dictionary.find_key(actor) # gets position actor is going from
	var to_position = from_position + direction # gets position actor is going to
	actor_dictionary[to_position] = actor_dictionary[from_position] # put actor in new position
	actor_dictionary.erase(from_position) # remove actor from old position
	actor_dictionary[to_position].move(map_to_local(to_position)) # visually move the actor's scene
	rewind_dictionary[actor].append(-direction) # append move direction to actor's rewind array
# function to destroy an actor
func destroy_actor(actor:Actor):
	var actor_key = actor_dictionary.find_key(actor)
	actor_dictionary.erase(actor_key)
	remove_child(actor)


# function to handle rewind input
func rewind_input():
	if not rewinding:
		start_rewind()
	else:
		activate_rewind()
# function to initiate a rewind, spawns cursor
func start_rewind():
	rewinding = true
	rewind_cursor = cursor_packed.instantiate()
	rewind_cursor.position = map_to_local(actor_dictionary.find_key(player))
	add_child(rewind_cursor)
# function to move the rewind cursor (NEEDS CHANGING)
func move_cursor(direction:Vector2i):
	rewind_cursor.position += Vector2(direction*tile_set.tile_size)
# function to rewind current target of rewind cursor
func activate_rewind():
	if actor_dictionary.has(local_to_map(rewind_cursor.position)):
		var rewind_actor = actor_dictionary[local_to_map(rewind_cursor.position)]
		if rewind_dictionary[rewind_actor].size() > 0:
			var rewind_direction = rewind_dictionary[rewind_actor][-1]
			make_move(rewind_actor, rewind_direction)
			rewind_dictionary[rewind_actor].pop_back()
			rewind_dictionary[rewind_actor].pop_back()
	end_rewind()
# function to remove rewind cursor, sets rewinding to false
func end_rewind():
	remove_child(rewind_cursor)
	rewind_cursor.queue_free()
	rewinding = false


# other functions
# function to undo the most recent move
func undo():
	if undo_array.size() > 0:
		restore_state(undo_array[-1])
		undo_array.pop_back()
# function to revert to a previous state
func restore_state(state:Array[Dictionary]):
	var restore_positions = state[0] # first entry of state is the position of every actor
	var actor_rewinds = state[1] # second entry is each actor's rewind array
	
	actor_dictionary.clear()
	for restore_position in restore_positions:
		var restore_actor = restore_positions[restore_position]
		if not restore_actor.is_inside_tree():
			add_child(restore_actor)
		actor_dictionary[restore_position] = restore_actor
		restore_actor.move(map_to_local(restore_position))
	
	rewind_dictionary.clear()
	rewind_dictionary = actor_rewinds.duplicate(true)
