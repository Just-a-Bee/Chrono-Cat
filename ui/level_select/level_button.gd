extends Control

@onready var level_select = get_parent()
@export var level:PackedScene

# vars for adjacent elements
@export var up_button:Node
@export var left_button:Node
@export var down_button:Node
@export var right_button:Node

func _on_button_up():
	get_parent().open_level.emit(level, name)
func clear():
	get_node("Check").show()
