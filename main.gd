extends Node2D
class_name Main

#Script for state autoload, changes game state, passing data like level completions between states

@onready var level_select = get_node("LevelSelect")
const TITLE_PATH = "res://ui/title.tscn"

# var to hold the current state
var state:int = STATES.SELECT
enum STATES
{
	SELECT = 0,
	LEVEL = 1
}

# pause vars
var is_paused:bool = false
var do_input:bool = false

# vars for level state
var level_node

# fade from black onready
func _ready():
	$Transitioner.fade_from_black()
	await $Transitioner.animation_finished
	do_input = true
# function to handle main input like pausing
func _input(event):
	if event.is_action_pressed("pause"):
		if do_input or is_paused:
			pause_input()

# function to handle pause button input
func pause_input():
	if is_paused:
		unpause()
	else:
		pause()

# function to pause the game
func pause():
	$PauseMenu.update_buttons()
	$PauseMenu.show()
	do_input = false
	is_paused = true
# function to unpause the game
func unpause():
	$PauseMenu.hide()
	do_input = true
	is_paused = false
# function to return to title screen
func return_to_title():
	do_input = false
	$Transitioner.fade_to_black()
	await $Transitioner.animation_finished
	get_tree().change_scene_to_file(TITLE_PATH)


# when a level is selected, open it
func open_level(level:PackedScene, level_name)->void:
	# fade to black
	do_input = false
	$Transitioner.fade_to_black()
	await $Transitioner.animation_finished
	#change the state
	$RewindBar.show()
	remove_child(level_select)
	level_node = level.instantiate()
	add_child(level_node)
	state = STATES.LEVEL
	# fade from black
	$Transitioner.fade_from_black()
	await $Transitioner.animation_finished
	do_input = true

# when a level is won, show win anim, then free it and go back to level select
func _on_level_win():
	# do animations
	do_input = false
	$WinAnim.show()
	$WinAnim.play()
	await $WinAnim.animation_finished
	level_select.clear_level()
	exit_level()
# function to exit the level and return to level select
func exit_level():
	do_input = false
	$Transitioner.fade_to_black()
	await $Transitioner.animation_finished
	# change the state
	$RewindBar.hide()
	$WinAnim.hide()
	remove_child(level_node)
	level_node.queue_free()
	add_child(level_select)
	
	state = STATES.SELECT
	# fade from black
	$Transitioner.fade_from_black()
	await $Transitioner.animation_finished
	do_input = true

func _on_rewind_uses_changed(new_rewinds):
	$RewindBar.value = new_rewinds
