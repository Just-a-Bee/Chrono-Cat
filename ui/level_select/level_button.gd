extends MapNode
class_name MapLevel

@export var level:PackedScene
@export var level_number:int = 0
@export var cleared = false

func _ready():
	$LevelNumber.text = str(level_number)
	if cleared:
		$LevelNumber.hide()
		$CompleteSprite.show()
		frame_coords = Vector2(1,0)

func clear():
	$AnimationPlayer.play("clear")
	cleared = true
