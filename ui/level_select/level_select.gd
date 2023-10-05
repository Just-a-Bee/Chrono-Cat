extends Node2D

signal open_level

func _ready():
	open_level.connect(get_parent()._on_level_select_open_level)

func _on_game_state_clear_level(level_name):
	get_node(level_name).clear()
