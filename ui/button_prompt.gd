@tool
extends HBoxContainer


@export var key:String = ''
@export var text:String = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	$ButtonIcon/PanelContainer/Key.text = key
	$Text.text = text


func _process(delta):
	if Engine.is_editor_hint():
		$ButtonIcon/PanelContainer/Key.text = key
		$Text.text = text
