extends Timer

const REPEATABLES = ["up", "down", "left", "right", "undo"]

var is_repeating
var repeat_event


func _ready():
	timeout.connect(_on_timeout)

func _input(event):
	if Globals.state == Globals.STATES.LEVEL:
		if is_repeatable(event):
			handle_repeat(event)
		handle_repeat_release(event)

#input repeat functions
#function to start repeating a repeatable input
func handle_repeat(event:InputEvent):
	if is_repeatable(event):
		is_repeating = true
		repeat_event = event
		self.start(Globals.DAS)
#handle releasing of a repeat event
func handle_repeat_release(event:InputEvent):
	if is_repeating and not event.is_pressed() and event.is_match(repeat_event):
		is_repeating = false
		repeat_event = null
		self.stop()
#function to return if an input is repeatable
func is_repeatable(event:InputEvent)->bool:
	if event.is_match(repeat_event):
		return false
	for action in REPEATABLES:
		if event.is_action_pressed(action):
			return true
	return false
#function to create input events on repeatTimer timeout
func _on_timeout():
	Input.parse_input_event(repeat_event)
	self.start(Globals.ARR)
