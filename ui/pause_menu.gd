extends Control

@onready var main:Main = get_parent()

func update_buttons():
	$VBoxContainer/Resume.grab_focus()
	if Globals.state != Globals.STATES.LEVEL:
		$VBoxContainer/HBoxContainer/ReturnToMap.hide()
	else:
		$VBoxContainer/HBoxContainer/ReturnToMap.show()

func _on_resume_button_up():
	main.unpause()


func _on_return_to_map_button_up():
	main.unpause()
	main.exit_level()


func _on_return_to_title_button_up():
	main.unpause()
	main.return_to_title()


func _on_settings_button_up():
	main.show_settings()
	set_enabled(false)

func set_enabled(value):
	$VBoxContainer/Resume.disabled = not value
	$VBoxContainer/Settings.disabled = not value
	$VBoxContainer/HBoxContainer/ReturnToMap.disabled = not value
	$VBoxContainer/HBoxContainer/ReturnToTitle.disabled = not value
