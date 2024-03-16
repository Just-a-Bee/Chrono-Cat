extends HBoxContainer

@export var key:String = ''
@export var text:String = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect/Key.text = key
	$Text.text = text
