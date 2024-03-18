extends Control

signal close

const pre_name:String = "[center][font_size=80]Congratulations!\n[font_size=60]"
const post_name:String = " has slept in every bed"

func appear():
	update_character()
	$AnimationPlayer.play("appear")

# Function to update the character displayed on congrats screen
func update_character():
	$Cat.texture = Globals.get_skin_texture()
	var skin_name = Globals.get_skin_name()
	if skin_name == "Orange":
		skin_name = "The Orange One"
	$VBoxContainer/RichTextLabel.text = pre_name + skin_name + post_name

func _on_button_button_up():
	close.emit()
	$AnimationPlayer.play_backwards("appear")
