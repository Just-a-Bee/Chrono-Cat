extends Polygon2D

# displays title of currently selected level

func appear():
	$AnimationPlayer.play("appear")
func disappear():
	$AnimationPlayer.play("hide")

func update_text(value:String):
	$Label.text = value
