extends AudioStreamPlayer

enum TRACKS {
	TITLE = 0,
	SELECT = 1,
	LEVEL_1 = 2,
	LEVEL_2 = 3
}

var tracklist = [
	null,
	preload("res://assets/sound/alt_idle_music_idea.mp3")
]

func play_track(track):
	stream = tracklist[track]
	play()

