extends Control

@onready var main = get_parent()

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
