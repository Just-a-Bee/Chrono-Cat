extends Node2D

#Script for state autoload, changes game state, passing data like level completions between states

@onready var level_select = get_node("LevelSelect")

# vars for level state
var current_level_name:String = ""
var level_node
signal clear_level

func _ready():
	clear_level.connect(level_select._on_game_state_clear_level) # connect clear level function to level select

# when a level is selected, open it
func _on_level_select_open_level(level:PackedScene, level_name)->void:
	current_level_name = level_name
	remove_child(level_select)
	level_node = level.instantiate()
	add_child(level_node)

# when a level is won, show win anim, then free it and go back to level select
func _on_level_win():
	$WinAnim.show()
	$WinAnim.play()
	await $WinAnim.animation_finished
	$WinAnim.hide()
	remove_child(level_node)
	level_node.queue_free()
	add_child(level_select)
	clear_level.emit(current_level_name)
	current_level_name = ""
