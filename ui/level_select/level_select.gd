extends Node2D

signal open_level

func _ready():
	open_level.connect(GameState.open_level)

func _on_button_button_up():
	open_level.emit(load("res://level_files/level.tscn"))
