extends Node2D

signal animation_finished

const FADE_TO_START_POS = Vector2(1920, 0)
const FADE_TO_END_POS = Vector2(-384, 0)
const FADE_FROM_START_POS = Vector2(-384, 0)
const FADE_FROM_END_POS = Vector2(-2688, 0)

func fade_to_black():
	$Fade.position = FADE_TO_START_POS
	var tween = get_tree().create_tween()
	tween.tween_property($Fade, "position", FADE_TO_END_POS, .5)
	await tween.finished
	animation_finished.emit()

func fade_from_black():
	$Fade.position = FADE_FROM_START_POS
	var tween = get_tree().create_tween()
	tween.tween_property($Fade, "position", FADE_FROM_END_POS, .5)
	await tween.finished
	animation_finished.emit()
	
