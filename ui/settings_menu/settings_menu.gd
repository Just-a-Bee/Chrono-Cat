extends Control
class_name SettingsMenu

signal closed

var do_test_sound:bool = false
var is_reset:bool = false

func _ready():
	update_buttons()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if is_reset:
			close_reset()
		else:
			close()

func get_focus():
	$CloseButton.grab_focus()

func update_buttons():
	if Globals.state == Globals.STATES.TITLE:
		$VBoxContainer/ResetButton.show()
	else:
		$VBoxContainer/ResetButton.hide()
	$VBoxContainer/Master.value = Globals.volume_setting_arr[0]
	$VBoxContainer/HBoxContainer/VBoxContainer/Music.value = Globals.volume_setting_arr[1]
	$VBoxContainer/HBoxContainer/VBoxContainer2/SfX.value = Globals.volume_setting_arr[2]
	do_test_sound = true

func _on_close_button_button_up():
	close()
func close():
	Globals.save_settings()
	hide()
	closed.emit()
	



# functions called by sliders to change volume
func _on_master_value_changed(value):
	change_volume(0,value)
func _on_music_value_changed(value):
	change_volume(1,value)
func _on_sf_x_value_changed(value):
	change_volume(2,value)
func change_volume(bus,value):
	Globals.set_bus_volume(bus,value)
	if do_test_sound:
		$AudioStreamPlayer.bus = AudioServer.get_bus_name(bus)
		$AudioStreamPlayer.play()

func set_enabled(value):
	$VBoxContainer/Master.editable = value
	$VBoxContainer/HBoxContainer/VBoxContainer/Music.editable = value
	$VBoxContainer/HBoxContainer/VBoxContainer2/SfX.editable = value
	$VBoxContainer/ResetButton.disabled = not value
	$CloseButton.disabled = not value

func _on_reset_button_button_up():
	$ResetPrompt.show()
	$ResetPrompt/Polygon2D/VBoxContainer/HBoxContainer/ResetNo.grab_focus()
	is_reset = true
	set_enabled(false)

func _on_reset_yes_button_up():
	Globals.reset_save()
	close_reset()

func _on_reset_no_button_up():
	close_reset()

func close_reset():
	is_reset = false
	$ResetPrompt.hide()
	set_enabled(true)
	get_focus()



