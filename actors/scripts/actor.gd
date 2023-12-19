extends Sprite2D
class_name Actor

@onready var level = get_parent()



func _ready():
	pass

#does not move actor in level's base, just moves the appearance of the actor, called by level
func move(new_position, _is_reverse:bool = false):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_position, .3).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	
# function to return behavior that should happen when self collides with actor
func collide(actor:Actor, _floor:Floor)->int:
	if actor == null:
		return level.COLLISION_BEHAVIORS.NONE
	if actor is Wall:
		return level.COLLISION_BEHAVIORS.STOP
	return level.COLLISION_BEHAVIORS.PUSH

# function to show destroying animation
func destroy():
	hide()
