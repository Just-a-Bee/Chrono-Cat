extends TileMap
class_name Level

@export var track = Music.TRACKS.LEVEL_1


var level_won:bool = false

signal exit
signal win
signal rewind_uses_changed
@onready var main = get_parent()

var sfx_packed = preload("res://level_files/level_sounds.tscn")
@onready var sfx = sfx_packed.instantiate()

# level item vars
# dictionary that contains all actors and their level positions
# floor dictionary contains all floor tiles and their level positions
# keys = positions, values = actor at position
var actor_dictionary:Dictionary
var floor_dictionary:Dictionary
@onready var player:Actor = get_node("Player")

# rewind vars
# instance of rewind cursor, added as child when rewinding
var rewind_cursor_packed:PackedScene = preload("res://level_files/rewind_cursor.tscn")
var rewind_cursor:Node2D = null
var rewinding:bool = false
var cursor_pos:Vector2i = Vector2i.ZERO
const CURSOR_MIN_X = 1
const CURSOR_MIN_Y = 1
const CURSOR_MAX_X = 13
const CURSOR_MAX_Y = 6

# dictionary that stores each actor and a list of its rewind positions
# keys = actor, values = array of rewind positions
var rewind_dictionary:Dictionary
var rewind_uses:int = 0 : set = set_rewind_uses # the number of times the player can use rewind
const CLOCK_REWINDS = 3

# stores a copy of game state every turn that can be reverted to
# state is composed of [actor_dictionary, rewind_dictionary, rewind_uses]
var undo_array:Array[Array]

# list of behaviors that can happen when actors collide
enum COLLISION_BEHAVIORS
{
	NONE = 0,
	PUSH = 1,
	STOP = 2,
	DESTROY = 3,
	COLLECT = 4,
	GET_COLLECTED = 5
}

# fill vars with level information, connect signals
func _ready():
	#index all actors
	index_actors()
	index_floor()
	win.connect(main._on_level_win)
	rewind_uses_changed.connect(main._on_rewind_uses_changed)
	add_child(sfx)
	

# function to index every actor into actor dictionary
func index_actors():
	for node in get_children():
		if node is Actor:
			actor_dictionary[local_to_map(node.position)] = node
			rewind_dictionary[node] = []
# function to index every floor into floor dictionary
func index_floor():
	for node in get_children():
		if node is Floor:
			floor_dictionary[local_to_map(node.position)] = node

# function to handle all gameplay input
func _input(event):
	if level_won:
		if event.is_action_pressed("ui_accept"):
			exit.emit()
	if not main.do_input:
		return
	
	var direction:Vector2i = get_direction(event)
	if direction != Vector2i.ZERO:
		move_input(direction)
	elif event.is_action_pressed("rewind"):
		rewind_input()
	elif event.is_action_pressed("cancel"):
		cancel_rewind()
	elif event.is_action_pressed("undo"):
		undo()
	elif event.is_action_pressed("restart"):
		restart()
	
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
# function to handle move input
func move_input(direction):
	if not rewinding:
		make_move(player, direction)
	else:
		move_cursor(direction)

# actor and movement functions
#function to try to move an actor, returns true if successfully moved
func make_move(actor:Actor, direction:Vector2i)->bool:
	# make a copy of the current state to save to undo arr
	var state:Array = [actor_dictionary.duplicate(true), rewind_dictionary.duplicate(true), rewind_uses]
	var actor_moved:bool = false # store if an actor has been moved
	var from_position:Vector2i = actor_dictionary.find_key(actor)
	var to_position:Vector2i = from_position + direction
	
	# if to_position is occupied, try to push
	if actor_dictionary.has(to_position) or floor_dictionary.has(to_position):
		
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
	# if a move was made, append the previous state to the undo array
	if actor_moved:
		if not rewinding: # if in a rewind, rewind sound should play instead
			sfx.play_move()
		undo_array.append(state) 
		return true
	return false
# function to handle when player collides with another actor
func handle_collision(target_position, push_array, direction):
	# iterate through positions until one is unoccupied, or we hit a wall and cant move
	while(actor_dictionary.has(target_position) or floor_dictionary.has(target_position)):
		var to_actor:Actor = null
		var to_floor:Floor = null
		if actor_dictionary.has(target_position):
			to_actor = actor_dictionary[target_position]
		if floor_dictionary.has(target_position):
			to_floor = floor_dictionary[target_position]
		
		var collision_behavior:int = push_array[-1].collide(to_actor, to_floor)
		
		if collision_behavior == COLLISION_BEHAVIORS.NONE:
			return
		elif collision_behavior == COLLISION_BEHAVIORS.PUSH: # adds that actor to push array
			push_array.append(to_actor)
			target_position += direction
		elif collision_behavior == COLLISION_BEHAVIORS.STOP: # returns because move cannot go through
			push_array.clear()
			return
		elif collision_behavior == COLLISION_BEHAVIORS.DESTROY: # removes previous actor from push array, both are destroyed
			move_actor(push_array[-1],direction)
			destroy_actor(to_actor)
			destroy_actor(push_array[-1])
			push_array.pop_at(-1)
		elif collision_behavior == COLLISION_BEHAVIORS.COLLECT: # actor is destroyed, a behavior happens based on actor
			collect_actor(to_actor)
		elif collision_behavior == COLLISION_BEHAVIORS.GET_COLLECTED: # moving actor gets collected
			collect_actor(push_array[-1])
			push_array.pop_back()
			return
func collect_actor(actor:Actor):
	if actor is Bed:
		win_level()
		
	if actor is Clock:
		rewind_uses += CLOCK_REWINDS
		player.do_rewind_particles()
		sfx.play_clock()
	destroy_actor(actor)
# function to move an actor, pass in actor to move and direction to move it
func move_actor(actor:Actor, direction:Vector2i, is_reverse:bool = false):
	var from_position = actor_dictionary.find_key(actor) # gets position actor is going from
	var to_position = from_position + direction # gets position actor is going to
	actor_dictionary[to_position] = actor_dictionary[from_position] # put actor in new position
	actor_dictionary.erase(from_position) # remove actor from old position
	actor_dictionary[to_position].move(map_to_local(to_position),is_reverse) # visually move the actor's scene
	rewind_dictionary[actor].append(-direction) # append move direction to actor's rewind array
# function to destroy an actor
func destroy_actor(actor:Actor):
	var actor_key = actor_dictionary.find_key(actor)
	actor_dictionary.erase(actor_key)
	actor.destroy()


# function to handle rewind input
func rewind_input():
	if rewind_uses > 0:
		if not rewinding:
			start_rewind()
		else:
			activate_rewind()
# function to initiate a rewind, spawns cursor
func start_rewind():
	rewinding = true
	rewind_cursor = rewind_cursor_packed.instantiate()
	add_child(rewind_cursor)
	cursor_pos = actor_dictionary.find_key(player)
	rewind_cursor.position = map_to_local(cursor_pos)
	rewind_cursor.appear()
# function to move the rewind cursor
func move_cursor(direction:Vector2i):
	var new_pos = cursor_pos + direction
	if in_cursor_bounds(new_pos):
		cursor_pos = new_pos
		rewind_cursor.move(map_to_local(cursor_pos))
# function to rewind current target of rewind cursor
func activate_rewind():
	var move_made:bool = false
	if actor_dictionary.has(cursor_pos):
		var rewind_actor = actor_dictionary[cursor_pos]
		if rewind_actor is Player:
			pass
		elif rewind_dictionary[rewind_actor].size() > 0:
			var rewind_direction = rewind_dictionary[rewind_actor][-1]
			move_made = make_move(rewind_actor, rewind_direction)
			if move_made:
				
				rewind_dictionary[rewind_actor].pop_back()
				rewind_dictionary[rewind_actor].pop_back()
				rewind_uses -= 1
	end_rewind(move_made)
# function to stop rewinding without activating it
func cancel_rewind():
	if rewinding:
		end_rewind()
# function to remove rewind cursor, sets rewinding to false
func end_rewind(did_rewind:bool = false):
	rewind_cursor.disappear(did_rewind)
	rewinding = false
# function to return if a cursor position is in bounds
func in_cursor_bounds(check_pos)->bool:
	if check_pos.x < CURSOR_MIN_X or check_pos.x > CURSOR_MAX_X:
		return false
	if check_pos.y < CURSOR_MIN_Y or check_pos.y > CURSOR_MAX_Y:
		return false
	return true

# other functions
# function to undo the most recent move
func undo():
	if undo_array.size() > 0:
		restore_state(undo_array[-1])
		undo_array.pop_back()
		sfx.play_undo()
#function to restart the level
func restart():
	if undo_array.size() > 0:
		restore_state(undo_array[0])
		undo_array.clear()
		sfx.play_restart()
# function to revert to a previous state
func restore_state(state:Array):
	if rewinding:
		cancel_rewind()
	var restore_positions = state[0] # first entry of state is the position of every actor
	var restore_rewinds = state[1] # second entry is each actor's rewind array
	var restore_rewind_uses = state[2] # third entry is number of rewind uses
	
	# move every actor to its previous position
	actor_dictionary.clear()
	for restore_position in restore_positions:
		var restore_actor = restore_positions[restore_position]
		if restore_actor.active == false:
			restore_actor.restore()
		actor_dictionary[restore_position] = restore_actor
		restore_actor.move(map_to_local(restore_position), true)
	
	# set the rewind array for every actor to the previous one
	rewind_dictionary.clear()
	for actor in restore_rewinds:
		rewind_dictionary[actor] = restore_rewinds[actor].duplicate()
	
	# set the number of rewind uses to previous amount
	rewind_uses = restore_rewind_uses

func win_level():
	sfx.play_win()
	win.emit()
	await get_tree().create_timer(1).timeout
	level_won = true
	await get_tree().create_timer(9).timeout
	exit.emit()

# set functions
# function to set rewind_uses, emits a signal
func set_rewind_uses(new_rewinds):
	rewind_uses = new_rewinds
	rewind_uses_changed.emit(new_rewinds)



