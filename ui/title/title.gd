extends Node2D

# script for the title menu

const MAIN = preload("res://main.tscn")

func _ready():
	# remove quit button if running on web
	if OS.has_feature("wasm"):
		$VBoxContainer/HBoxContainer/Quit.hide()
	
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
	get_tree().root.add_child(MAIN.instantiate())
	await get_tree().process_frame
	get_tree().root.remove_child(self)
	queue_free()
	


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
