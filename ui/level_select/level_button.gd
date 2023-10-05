extends Button

@onready var level_select = get_parent()
@export var level:PackedScene

func _ready():
	text = name
func _on_button_up():
	get_parent().open_level.emit(level, name)
func clear():
	get_node("Check").show()
