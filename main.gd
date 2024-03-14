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
	load_game()
	$AnimationPlayer.play("fade_from_black")
	$SettingsMenu.update_buttons()
	await $AnimationPlayer.animation_finished
	Music.play_track(Music.TRACKS.SELECT)
	do_input = true

# function to handle main input like pausing
func _input(event):
	if event.is_action_pressed("pause"):
		if do_input or is_paused:
			pause_input()

# function to handle pause button input
func pause_input():
	if is_paused:
		if not is_settings:
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

func _on_settings_menu_closed():
	$PauseMenu.set_enabled(true)
	await get_tree().process_frame
	is_settings = false


# function to return to title screen
func return_to_title():
	do_input = false
	Music.stop()
	$AnimationPlayer.play("fade_to_black")
	await $AnimationPlayer.animation_finished
	Globals.state = Globals.STATES.TITLE
	get_tree().change_scene_to_file(TITLE_PATH)


# when a level is selected, open it
func open_level(level:PackedScene, level_num, level_name)->void:
	# fade to black
	do_input = false
	Music.stop()
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
	Music.play_track(level_node.track)

# when a level is won, show win anim, then free it and go back to level select
func _on_level_win():
	# do animations
	do_input = false
	await level_node.exit
	level_select.clear_level()
	exit_level()

# function to exit the level and return to level select
func exit_level():
	Music.stop()
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
	Music.play_track(Music.TRACKS.SELECT)

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
	await $AnimationPlayer/RewindTutorial.close
	$AnimationPlayer.play("close_rewind_tutorial")


func show_settings():
	$SettingsMenu.show()
	is_settings = true
func hide_settings():
	$SettingsMenu.hide()
	is_settings = false

# saves the game to file
func save_game():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	var clear_arr = level_select.get_clears()
	var clear_str = ""
	for i in clear_arr:
		if i == true:
			clear_str += "1"
		else:
			clear_str += "0"
	save_game.store_line(clear_str)
	
	var rewind_string = ""
	if Globals.rewind_unlocked:
		rewind_string = "1"
	else:
		rewind_string = "0"
	save_game.store_line(rewind_string)

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return
	var load_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	
	var clear_str = load_game.get_line()
	var clear_arr = []
	for i in clear_str.length():
		clear_arr.append(clear_str[i] == '1')
	level_select.set_clears(clear_arr)
	
	var rewind_string = load_game.get_line()
	Globals.rewind_unlocked = (rewind_string == '1')



