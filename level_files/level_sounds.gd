extends Node

func play_undo():
	$UndoSound.play()
func play_restart():
	$RestartSound.play()
func play_move():
	$MoveSound.play()
func play_clock():
	$ClockSound.play() # played when you collect a clock
func play_win():
	$WinSound.play()
