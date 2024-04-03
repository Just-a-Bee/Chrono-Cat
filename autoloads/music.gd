extends AudioStreamPlayer

enum TRACKS {
	TITLE = 0,
	SELECT = 1,
	LEVEL_1 = 2,
	LEVEL_2 = 3
}

var tracklist = [
	preload("res://assets/sound/music/title.ogg"),
	preload("res://assets/sound/music/level_select.ogg"),
	preload("res://assets/sound/music/level_1.ogg"),
	preload("res://assets/sound/music/level_2.ogg")
]

func _ready():
	bus = AudioServer.get_bus_name(Globals.BUSSES.MUSIC)

func play_track(track):
	stream = tracklist[track]
	play()

