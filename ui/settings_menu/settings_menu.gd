extends Control

const volume_arr = [0,-50,-10,-5,-1,0,1,2,3,4,5]

func update_buttons():
	if Globals.state == Globals.STATES.TITLE:
		$VBoxContainer/ResetButton.show()
	else:
		$VBoxContainer/ResetButton.hide()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		close()

func close():
	hide()

func _on_close_button_button_up():
	close()

# functions called by sliders to change volume
func _on_master_value_changed(value):
	set_bus_volume(0,value)
func _on_music_value_changed(value):
	set_bus_volume(1,value)
func _on_sf_x_value_changed(value):
	set_bus_volume(2,value)
# function to set the volume of a bus, converts slider value into db value
func set_bus_volume(bus, value):
	AudioServer.set_bus_mute(bus, value==0) # if the value is 0, mute the bus
	
	var volume_db = volume_arr[value]
	AudioServer.set_bus_volume_db(bus,value)
	$AudioStreamPlayer.bus = AudioServer.get_bus_name(bus)
	$AudioStreamPlayer.play()






