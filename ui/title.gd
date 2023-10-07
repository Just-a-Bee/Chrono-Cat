extends Node2D

# script for the title menu

const MAIN_PATH = "res://main.tscn"

func _on_play_button_up():
	$Transitioner.fade_to_black()
	await $Transitioner.animation_finished
	get_tree().change_scene_to_file(MAIN_PATH)


func _on_settings_button_up():
	pass


func _on_quit_button_up():
	get_tree().quit()
