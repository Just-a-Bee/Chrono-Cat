extends TextureRect

signal close

const TUTORIAL_IMAGES = [
	
]

const TUTORIAL_TEXTS = [
	"[center]You've collected a clock, now you can use the [color=yellow]Rewind[/color] ability",
	"[center]Press X to open the cursor and then move it with the arrow keys",
	"[center]Select an object and press X again to move it [color=yellow]back in time[/color]",
	"[center]The meter in the corner indicates how many times you can [color=yellow]Rewind[/color]"
]
var text_index = 0;


func _ready():
	update_text()

func update_text():
	# disable left and right buttons if at max
	$VBoxContainer/TextBox/Left.disabled = (text_index == 0)
	$VBoxContainer/TextBox/Right.disabled = (text_index == TUTORIAL_TEXTS.size()-1)
	
	$VBoxContainer/TextBox/Text.text = TUTORIAL_TEXTS[text_index];


func _on_close_button_up():
	close.emit()


func _on_left_button_up():
	change_text(-1)
func _on_right_button_up():
	change_text(1)
func change_text(value):
	text_index += value
	update_text()
