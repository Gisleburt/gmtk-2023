extends PointLight2D

var parent: CharacterBody2D
var look_dir: Vector2 = Vector2.DOWN

const CONE_ROTATE = 3 * 0.7854

func _ready() -> void:
	parent = get_parent()

func _process(_delta: float) -> void:
	var v: Vector2 = parent.actual_velocity
	var pos: Vector2 = parent.global_position
	
	print(v)

	if v.length() > 0:
		look_dir = v.normalized()

	look_at(look_dir.rotated(CONE_ROTATE) + pos)
