extends AnimatedSprite2D

enum Direction {UP, DOWN, LEFT, RIGHT}

var last_direction: Direction = Direction.DOWN
var was_running: bool = true;
var parent: CharacterBody2D


func _ready() -> void:
	parent = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var v: Vector2 = parent.actual_velocity

	if v.length() > 0:
		var direction = get_direction(v)
		if direction != last_direction or not was_running:
			set_run_animation(direction)
			last_direction = direction
			was_running = true

	elif was_running:
		set_idle_animation(last_direction)
		was_running = false

func get_direction(v: Vector2) -> Direction:
	var nv = v.normalized();
	if nv.x > 0.5:
		return Direction.RIGHT

	if nv.x < -0.5:
		return Direction.LEFT

	if nv.y < -0.5:
		return Direction.UP

	return Direction.DOWN

func set_run_animation(d: Direction) -> void:
	if d == Direction.RIGHT:
		return play("runRight")

	if d == Direction.LEFT:
		return play("runLeft")

	if d == Direction.UP:
		return play("runUp")
	
	return play("runDown")

func set_idle_animation(d: Direction) -> void:
	if d == Direction.RIGHT:
		return play("idleRight")

	if d == Direction.LEFT:
		return play("idleLeft")

	if d == Direction.UP:
		return play("idleUp")
	
	return play("idleDown")
