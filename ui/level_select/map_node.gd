extends Sprite2D
class_name MapNode

@onready var level_select = get_parent()



@export var unlocked:bool = false

# vars for adjacent elements
@export var up_node:Node = null
@export var left_node:Node = null
@export var down_node:Node = null
@export var right_node:Node = null

@onready var adjacent_nodes:Dictionary = {"up" = up_node, "left" = left_node, "down" = down_node, "right" = right_node}

func unlock_adjacent():
	for node in adjacent_nodes.values():
		if node != null:
			node.unlocked = true
