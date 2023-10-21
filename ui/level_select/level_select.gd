extends Node2D

signal open_level

var current_level:Node = null

@onready var main = get_parent()

# connect open level signal to main
func _ready():
	select_level(get_node("Having a Nap"))

# handle level select inputs
func _input(event):
	if not main.do_input:
		return
	direction_input(event)
	if event.is_action_pressed("ui_accept"):
		main.open_level(current_level.level, current_level.name)

# handle directional inputs, move cursor in direction pressed
func direction_input(event:InputEvent):
	var new_select = null
	if event.is_action_pressed("left"):
		new_select = current_level.left_button
	elif event.is_action_pressed("up"):
		new_select = current_level.up_button
	elif event.is_action_pressed("down"):
		new_select = current_level.down_button
	elif event.is_action_pressed("right"):
		new_select = current_level.right_button
	if new_select != null:
		select_level(new_select)


# function to select a different level
func select_level(new_select):
	current_level = new_select
	$LevelTitle.text = current_level.name
	$Player.position = current_level.position

# when main tells us a level was cleared, give that level a checkmark
func clear_level():
	current_level.clear()
