extends AudioStreamPlayer

enum TRACKS {
	TITLE = 0,
	SELECT = 1,
	LEVEL_1 = 2,
	LEVEL_2 = 3
}

var tracklist = [
	preload("res://assets/sound/title.ogg"),
	preload("res://assets/sound/level_select.ogg"),
	preload("res://assets/sound/level_1.ogg"),
	null
]

func play_track(track):
	stream = tracklist[track]
	play()

