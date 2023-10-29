extends Sprite2D
class_name Actor

@onready var level:Level = get_parent()

var tween:Tween = null
var tween_position:Vector2

func _ready():
	tween = get_tree().create_tween()
	tween.stop()

#does not move actor in level's base, just moves the appearance of the actor, called by level
func move(new_position):
	if tween.is_running():
		tween.stop()
		position = tween_position
	tween = get_tree().create_tween()
	tween_position = new_position
	tween.tween_property(self, "position", tween_position, .3).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
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
