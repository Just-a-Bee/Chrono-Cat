extends Node2D

signal open_level

const NUM_LEVELS = 1

var current_node:Node = null
var cleared_levels:int = 0


@onready var main = get_parent()

# connect open level signal to main
func _ready():
	select_level(get_node("Start"), null, true)
	$Player.texture = Globals.get_skin_texture()

# handle level select inputs
func _input(event):
	if main.do_input == false or Globals.state != Globals.STATES.SELECT:
		return
	direction_input(event)
	if event.is_action_pressed("ui_accept"):
		if current_node is MapLevel:
			main.open_level(current_node.level, current_node.level_number, current_node.name)

# handle directional inputs, move cursor in direction pressed
func direction_input(event:InputEvent):
	var new_select = null
	var move_dir = null
	if event.is_action_pressed("left"):
		new_select = current_node.left_node
		move_dir = Vector2.LEFT
	
	elif event.is_action_pressed("up"):
		new_select = current_node.up_node
		move_dir = Vector2.UP
	
	elif event.is_action_pressed("down"):
		new_select = current_node.down_node
		move_dir = Vector2.DOWN
	
	elif event.is_action_pressed("right"):
		new_select = current_node.right_node
		move_dir = Vector2.RIGHT
	
	if new_select != null:
		select_level(new_select, move_dir)


# function to select a different level
func select_level(new_select, move_dir, instant = false):
	
	# dont select level if it isnt unlocked
	if current_node is MapLevel and not current_node.cleared:
		if move_dir != Vector2.LEFT:
			return

	main.do_input = false
	
	
	if current_node is MapLevel:
		$LevelTitle.disappear()
	current_node = new_select
	
	# move player to level
	if instant:
		$Player.position = current_node.position
	else:
		# player moving animation
		$Player/AnimationPlayer.play("walk")
		if move_dir == Vector2.RIGHT:
			$Player.flip_h = false
		elif move_dir == Vector2.LEFT:
			$Player.flip_h = true
		var tween = get_tree().create_tween()
		tween.tween_property($Player, "position", current_node.position, .6)
		if current_node is MapLevel:
			$LevelTitle.update_text(current_node.name)
			$LevelTitle.appear()
		await tween.finished
		$Player/AnimationPlayer.play("stand")
	

	main.do_input = true

# when main tells us a level was cleared, give that level a checkmark
func clear_level():
	if not current_node.cleared:
		current_node.clear()
		main.save_game()
		cleared_levels += 1
		update_clear_count(true)

# function to update the cleared level counter
func update_clear_count(justCleared:bool):
	$ClearCount.text = str(cleared_levels) + "/" + str(NUM_LEVELS)
	if (cleared_levels == NUM_LEVELS) and justCleared:
		main.do_input = false
		await get_tree().create_timer(3).timeout
		$Congrats.appear()
		await $Congrats.close
		main.do_input = true


# function to return array of all level buttons
func get_levels():
	var level_arr = []
	for node in get_children():
		if node is MapLevel:
			level_arr.append(node)
	return level_arr
# function to return array of cleared levels
func get_clears():
	var clear_arr = []
	for level in get_levels():
		clear_arr.append(level.cleared)
	return clear_arr
# function to set levels to be cleared or uncleared
func set_clears(cleared_array):
	var level_arr = get_levels()
	for i in cleared_array.size():
		if cleared_array[i]:
			level_arr[i].cleared = true
			level_arr[i].fast_clear()
			cleared_levels += 1
	update_clear_count(false)
