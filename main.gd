extends Node2D

#Script for state autoload, changes game state, passing data like level completions between states

@onready var level_select = get_node("LevelSelect")

# var to hold the current state
var state:int = STATES.SELECT
enum STATES
{
	SELECT = 0,
	LEVEL = 1
}



# pause vars
var is_paused:bool = false


# vars for level state
var current_level_name:String = ""
var level_node
signal clear_level

func _ready():
	clear_level.connect(level_select._on_game_state_clear_level) # connect clear level function to level select
	$Transitioner.fade_from_black()

func _input(event):
	if event.is_action_pressed("pause"):
		pause_input()

# function to handle pause button input
func pause_input():
	if is_paused:
		unpause()
	else:
		pause()

# function to pause the game
func pause():
	if state == STATES.LEVEL:
		level_node.do_input = false
	$PauseMenu.show()
	is_paused = true
# function to unpause the game
func unpause():
	if state == STATES.LEVEL:
		level_node.do_input = true
	$PauseMenu.hide()
	is_paused = false
	


# when a level is selected, open it
func _on_level_select_open_level(level:PackedScene, level_name)->void:
	# fade to black
	$Transitioner.fade_to_black()
	await $Transitioner.animation_finished
	#change the state
	current_level_name = level_name
	remove_child(level_select)
	level_node = level.instantiate()
	add_child(level_node)
	state = STATES.LEVEL
	# fade from black
	$Transitioner.fade_from_black()
	await $Transitioner.animation_finished
	level_node.do_input = true

# when a level is won, show win anim, then free it and go back to level select
func _on_level_win():
	# do animations
	$WinAnim.show()
	$WinAnim.play()
	await $WinAnim.animation_finished
	clear_level.emit(current_level_name)
	exit_level()
# function to exit the level and return to level select
func exit_level():
	$Transitioner.fade_to_black()
	await $Transitioner.animation_finished
	# change the state
	$WinAnim.hide()
	remove_child(level_node)
	level_node.queue_free()
	add_child(level_select)
	
	current_level_name = ""
	state = STATES.SELECT
	# fade from black
	$Transitioner.fade_from_black()
