extends HBoxContainer
class_name SkinSelector


func _ready():
	$SkinLabel.text = Globals.get_skin_name()

func _on_skin_left_button_up():
	change_skin(-1)


func _on_skin_right_button_up():
	change_skin(1)

func change_skin(value):
	Globals.change_skin(value)
	$SkinLabel.text = Globals.get_skin_name()
