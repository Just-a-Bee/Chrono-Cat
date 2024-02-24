extends Node

# settings vars
var ARR:float = .3
var DAS:float = .4
const VOLUME_VALUES:Array = [0,-50,-5,-1,0,1,3,4,5]
var volume_setting_arr:Array = [4,4,4]
var skin_index = 0
const skin_count = 3
const skin_textures = [
	preload("res://assets/actors/Calico.png"),
	preload("res://assets/actors/Tabby.png"),
	preload("res://assets/actors/Orange.png")
]
const skin_names = [
	"Chrono Cat",
	"Time Tabby",
	"Orange"
]


# progress related vars
var rewind_unlocked:bool = false

# state vars
var state:int = STATES.TITLE : set = _set_state
enum STATES
{
	TITLE = 0,
	SELECT = 1,
	LEVEL = 2
}
signal state_changed

enum BUSSES
{
	MASTER = 0,
	MUSIC = 1,
	SFX = 2
}


func _set_state(new_state):
	state = new_state
	state_changed.emit()

func _ready():
	load_settings()

# function to set the volume of a bus, converts slider value into db value
func set_bus_volume(bus, value):
	AudioServer.set_bus_mute(bus, value==0) # if the value is 0, mute the bus
	
	var volume_db = VOLUME_VALUES[value]
	volume_setting_arr[bus] = value
	AudioServer.set_bus_volume_db(bus,volume_db)


func reset_save():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_game.store_line('0')
	save_game.store_line('0')

func save_settings():
	var save_settings = FileAccess.open("user://savesettings.save", FileAccess.WRITE)
	var volume_str = ""
	for i in volume_setting_arr:
		volume_str += str(i)
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

# function to change the skin for the cat
func change_skin(value):
	skin_index += value
	if skin_index >= skin_count:
		skin_index = 0
	if skin_index < 0:
		skin_index = skin_count-1
	for node in get_tree().get_nodes_in_group("cat"):
		node.texture = get_skin_texture()
	
	
func get_skin_texture():
	return skin_textures[skin_index]
func get_skin_name():
	return skin_names[skin_index]
