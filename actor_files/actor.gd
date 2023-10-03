extends Sprite2D
class_name Actor

@export var is_wall:bool
@export var is_key:bool
@export var is_lock:bool
@export var is_collectable:bool
@export var is_objective:bool
@export var is_player:bool
@export var is_clock:bool

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
func collide(actor:Actor)->int:
	if is_player and actor.is_collectable:
		return level.COLLISION_BEHAVIORS.COLLECT
	if is_collectable and actor.is_player:
		return level.COLLISION_BEHAVIORS.GET_COLLECTED
	if is_key and actor.is_lock:
		return level.COLLISION_BEHAVIORS.DESTROY
	if actor.is_wall:
		return level.COLLISION_BEHAVIORS.STOP
	return level.COLLISION_BEHAVIORS.PUSH
	
