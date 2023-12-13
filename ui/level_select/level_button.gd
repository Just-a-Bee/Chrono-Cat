extends MapNode

@export var level:PackedScene
@export var level_number:int = 0

func _ready():
	$LevelNumber.text = str(level_number)

func _on_button_up():
	get_parent().open_level.emit(level, name)
func clear():
	$CompleteSprite.show()
	unlock_adjacent()
