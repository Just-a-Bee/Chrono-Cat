extends Node2D

signal open_level

var current_node:Node = null

@onready var main = get_parent()

# connect open level signal to main
func _ready():
	select_level(get_node("StartPos"), null, true)

# handle level select inputs
func _input(event):
	if main.do_input == false or Globals.state != Globals.STATES.SELECT:
		return
	direction_input(event)
	if event.is_action_pressed("ui_accept"):
		if current_node is MapLevel:
			print("telling main to open level")
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
	if not new_select.unlocked:
		return

	main.do_input = false
	
	
	
	$LevelTitle.text = ""
	current_node = new_select
	
	# move player to level
	if instant:
		$Player.position = current_node.position
	else:
		# player moving animation
		$Player.play("walk")
		if move_dir == Vector2.RIGHT:
			$Player.flip_h = false
		elif move_dir == Vector2.LEFT:
			$Player.flip_h = true
		var tween = get_tree().create_tween()
		tween.tween_property($Player, "position", current_node.position, .6)
		await tween.finished
		$Player.play("stand")
	
	if current_node is MapLevel:
		$LevelTitle.text = current_node.name
	main.do_input = true

# when main tells us a level was cleared, give that level a checkmark
func clear_level():
	current_node.clear()
