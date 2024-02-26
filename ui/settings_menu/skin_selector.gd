extends HBoxContainer
class_name SkinSelector

# script for skin selector ui element

# update label text on ready
func _ready():
	$SkinLabel.text = Globals.get_skin_name()
	$Control/Sprite2D.texture = Globals.get_skin_texture()
# button press functions
func _on_skin_left_button_up():
	change_skin(-1)
func _on_skin_right_button_up():
	change_skin(1)
# function to change the player skin in globals
func change_skin(value):
	Globals.change_skin(value)
	$SkinLabel.text = Globals.get_skin_name()
	$Control/Sprite2D.texture = Globals.get_skin_texture()
