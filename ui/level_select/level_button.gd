extends MapNode
class_name MapLevel

@export var level:PackedScene
@export var level_number:int = 0
@export var cleared = false

func _ready():
	$LevelNumber.text = str(level_number)
	if cleared:
		fast_clear()


func clear():
	$AnimationPlayer.play("clear")
	cleared = true

# function to clear instantly, no anim
func fast_clear():
	$LevelNumber.hide()
	$CompleteSprite.show()
	frame_coords = Vector2(1,0)

func show_prompt():
	$AnimationPlayer.play("show_prompt")
func hide_prompt():
	$AnimationPlayer.queue("hide_prompt")
