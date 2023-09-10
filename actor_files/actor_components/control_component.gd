extends Node2D
class_name ControlComponent


func _input(event)->void:
	var direction:Vector2i = get_direction(event)
	if direction != Vector2i.ZERO:
		make_move(direction)
	

#function to return input direction of event, if there isnt one it returns Vector2i.ZERO
func get_direction(event)->Vector2i:
	if event.is_action_pressed("up"):
		return Vector2i.UP
	if event.is_action_pressed("left"):
		return Vector2i.LEFT
	if event.is_action_pressed("right"):
		return Vector2i.RIGHT
	if event.is_action_pressed("down"):
		return Vector2i.DOWN
	return Vector2i.ZERO

#function to move actor in direction
func make_move(direction:Vector2i)->void:
	get_parent().get_parent().try_move(get_parent(), direction)
