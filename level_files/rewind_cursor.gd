extends Sprite2D


@onready var level:Level = get_parent()

func _ready():
	pass
#does not move actor in level's base, just moves the appearance of the actor, called by level
func move(new_position):
	$Arrow.hide()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_position, .3).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	$ArrowTimer.start()

# function to update cursor's arrow indicator
func update_arrow():
	if level.actor_dictionary.has(level.cursor_pos):
		var hovered_actor = level.actor_dictionary[level.cursor_pos]
		if level.rewind_dictionary[hovered_actor].size() > 0:
			var rewind_direction = level.rewind_dictionary[hovered_actor][-1]
			set_arrow_rotation(rewind_direction)
			$Arrow.show()

func set_arrow_rotation(direction:Vector2i):
	if direction == Vector2i.RIGHT:
		$Arrow.rotation = 0
	if direction == Vector2i.DOWN:
		$Arrow.rotation = PI/2
	if direction == Vector2i.LEFT:
		$Arrow.rotation = PI
	if direction == Vector2i.UP:
		$Arrow.rotation = -PI/2


func _on_arrow_timer_timeout():
	update_arrow()
