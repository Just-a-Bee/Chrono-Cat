extends Node2D
class_name Main

#Script for state autoload, changes game state, passing data like level completions between states


@onready var level_select = get_node("LevelSelect")
const TITLE_PATH = "res://ui/title/title.tscn"

# pause vars
var is_paused:bool = false
var is_settings:bool = false
@export var do_input:bool = false

# vars for level state
var level_node

# fade from black onready
func _ready():
	$AnimationPlayer.play("fade_from_black")
	await $AnimationPlayer.animation_finished
	do_input = true

# function to handle main input like pausing
func _input(event):
	if event.is_action_pressed("pause"):
		if do_input or is_paused:
			pause_input()

# function to handle pause button input
func pause_input():
	if is_paused:
		if is_settings:
			hide_settings()
		else:
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
	$AnimationPlayer.play("fade_to_black")
	await $AnimationPlayer.animation_finished
	Globals.state = Globals.STATES.TITLE
	get_tree().change_scene_to_file(TITLE_PATH)


# when a level is selected, open it
func open_level(level:PackedScene, level_num, level_name)->void:
	# fade to black
	print("opening level")
	do_input = false
	$AnimationPlayer.play("fade_to_black")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer/LevelNum.text = "Level " + str(level_num)
	$AnimationPlayer/TitleBar/Label.text = level_name
	$AnimationPlayer.play("show_title")
	await $AnimationPlayer.animation_finished
	
	
	#change the state
	$RewindBar.value = 0
	if Globals.rewind_unlocked:
		$RewindBar.show()
	level_select.hide()
	level_node = level.instantiate()
	add_child(level_node)
	Globals.state = Globals.STATES.LEVEL
	
	# show level title
	$AnimationPlayer.play("show_title")
	
	# fade from black
	$AnimationPlayer.play("fade_from_black")
	await $AnimationPlayer.animation_finished
	do_input = true

# when a level is won, show win anim, then free it and go back to level select
func _on_level_win():
	# do animations
	do_input = false
	await get_tree().create_timer(10).timeout
	level_select.clear_level()
	exit_level()
# function to exit the level and return to level select
func exit_level():
	do_input = false
	$AnimationPlayer.play("fade_to_black")
	await $AnimationPlayer.animation_finished
	# change the state
	$RewindBar.hide()
	remove_child(level_node)
	level_node.queue_free()
	level_select.show()
	
	Globals.state = Globals.STATES.SELECT
	# fade from black
	$AnimationPlayer.play("fade_from_black")
	await $AnimationPlayer.animation_finished
	do_input = true

# function to update the value displayed on the rewind bar, if initial unlock, play animation
func _on_rewind_uses_changed(new_rewinds):
	if not Globals.rewind_unlocked and new_rewinds > 0:
		unlock_rewind()
	else:
		var tween = get_tree().create_tween()
		tween.tween_property($RewindBar, "value", new_rewinds, .3).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)

# function to show unlocking animation for rewind ability
func unlock_rewind():
	$AnimationPlayer.play("unlock_rewind")
	Globals.rewind_unlocked = true
	await $RewindTutorial/VBoxContainer/Button.button_up
	$AnimationPlayer.play("close_rewind_tutorial")


func show_settings():
	$SettingsMenu.show()
	is_settings = true
func hide_settings():
	$SettingsMenu.hide()
	is_settings = false
