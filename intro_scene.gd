extends Node2D

func _ready():
	$SleepyCat/Player/SleepParticles.emitting = true
	$AnimationPlayer.play("Intro")
