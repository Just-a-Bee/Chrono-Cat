extends Node2D

signal open_level

# connect open level signal to main
func _ready():
	open_level.connect(get_parent()._on_level_select_open_level)

# when main tells us a level was cleared, give that level a checkmark
func clear_level(level_name):
	get_node(level_name).clear()
