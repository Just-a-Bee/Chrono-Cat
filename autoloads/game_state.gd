extends Node

#Script for state autoload, changes game state, passing data like level completions between states


var level_select_file:PackedScene = preload("res://ui/level_select/level_select.tscn")



func open_level(level:PackedScene)->void:
	get_tree().change_scene_to_packed(level)

func win_level():
	get_tree().change_scene_to_packed(level_select_file)
