extends Sprite2D
class_name Actor

@export var is_wall:bool
@export var is_key:bool
@export var is_lock:bool

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
	tween.tween_property(self, "position", tween_position, .075)
	

func collide(actor:Actor)->int:
	if is_key and actor.is_lock:
		return level.COLISSION_BEHAVIORS.DESTROY
	if actor.is_wall:
		return level.COLISSION_BEHAVIORS.STOP
	return level.COLISSION_BEHAVIORS.PUSH
	
