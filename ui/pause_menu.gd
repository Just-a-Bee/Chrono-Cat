extends Control

@onready var main:Main = get_parent()

func update_buttons():
	$VBoxContainer/Resume.grab_focus()
	if main.state != main.STATES.LEVEL:
		$VBoxContainer/ReturnToMap.hide()
	else:
		$VBoxContainer/ReturnToMap.show()

func _on_resume_button_up():
	main.unpause()


func _on_return_to_map_button_up():
	main.unpause()
	main.exit_level()


func _on_return_to_title_button_up():
	main.unpause()
	main.return_to_title()


func _on_settings_button_up():
	pass
