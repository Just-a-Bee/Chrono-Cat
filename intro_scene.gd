extends Node2D

signal finished

func play():
	#$SleepyCat/Player/SleepParticles.emitting = true
	$AnimationPlayer.play("Intro")
	$Bubbles/AnimationPlayer.play("float")
	await $AnimationPlayer.animation_finished
	finished.emit()
