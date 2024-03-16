extends Node2D

# script for the title menu

const MAIN_PATH = "res://main.tscn"

func _ready():
	$VBoxContainer/Play.grab_focus()
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
	$SettingsMenu.get_focus()


func _on_quit_button_up():
	get_tree().quit()


func _on_credits_button_up():
	$Credits/AnimationPlayer.play("show")


func _on_credits_x_button_up():
	$Credits/AnimationPlayer.play("hide")


func _on_settings_menu_closed():
	$VBoxContainer/Play.grab_focus()

# function to open a link when one is clicked in credits
func _on_rich_text_label_meta_clicked(meta):
	OS.shell_open(str(meta))
