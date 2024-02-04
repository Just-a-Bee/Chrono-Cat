extends Node

# settings vars
var ARR = .3
var DAS = .4
const VOLUME_VALUES = [0,-50,-5,-1,0,1,3,4,5]
var volume_setting_arr = [4,4,4]

# progress related vars
var rewind_unlocked:bool = false

# state vars
var state:int = STATES.TITLE
enum STATES
{
	TITLE = 0,
	SELECT = 1,
	LEVEL = 2
}

func _ready():
	load_settings()

# function to set the volume of a bus, converts slider value into db value
func set_bus_volume(bus, value):
	AudioServer.set_bus_mute(bus, value==0) # if the value is 0, mute the bus
	
	var volume_db = VOLUME_VALUES[value]
	volume_setting_arr[bus] = value
	AudioServer.set_bus_volume_db(bus,value)


func reset_save():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_game.store_line('0')
	save_game.store_line('0')

func save_settings():
	var save_settings = FileAccess.open("user://savesettings.save", FileAccess.WRITE)
	var volume_str = ""
	for i in volume_setting_arr:
		volume_str += str(i)
		print(volume_str)
	save_settings.store_line(volume_str)
	
func load_settings():
	if not FileAccess.file_exists("user://savesettings.save"):
		return
	var load_settings = FileAccess.open("user://savesettings.save", FileAccess.READ)
	var volume_str = load_settings.get_line()
	if volume_str.length() > volume_setting_arr.size():
		return
	for i in volume_str.length():
		set_bus_volume(i, int(volume_str[i]))
