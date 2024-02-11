extends Node2D

# script for the title menu

const MAIN_PATH = "res://main.tscn"

func _ready():
	$Transitioner.fade_from_black()
	$TextureRect/AnimationPlayer.play("scroll")
	await $Transitioner.animation_finished
	Music.play_track(Music.TRACKS.TITLE)

func _on_play_button_up():
	Music.stop()
	$Transitioner.fade_to_black()
	await $Transitioner.animation_finished
	Globals.state = Globals.STATES.SELECT
	get_tree().change_scene_to_file(MAIN_PATH)


func _on_settings_button_up():
	$SettingsMenu.show()


func _on_quit_button_up():
	get_tree().quit()


func _on_credits_button_up():
	$Credits/AnimationPlayer.play("show")


func _on_credits_x_button_up():
	$Credits/AnimationPlayer.play("hide")
