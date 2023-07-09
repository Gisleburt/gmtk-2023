extends PathFinder

class_name MoneyFinder

enum Behaviour { FINDING_MONEY, RUNNING_AWAY, ESCAPING }

@export var guard: CharacterBody2D
@onready var guard_detector: Area2D = $GuardDetector
var current_behaviour: Behaviour = Behaviour.FINDING_MONEY
var guard_visible: bool = false

func _ready() -> void:
	super()
	guard_detector.connect("body_entered", guard_detected)
	guard_detector.connect("body_exited", guard_lost)
	set_next_money()

func _process(_delta: float) -> void:
	if agent.is_navigation_finished():
		current_behaviour = Behaviour.FINDING_MONEY
		set_next_money()

func set_next_money() -> void:
	var money: Array = get_tree().get_nodes_in_group("Money");
	if money.size() > 0:
		set_target(money[randi() % money.size()].global_position)
	else:
		escape()

func run_away() -> void:
	current_behaviour = Behaviour.RUNNING_AWAY

	var viable_targets = map.get_used_cells(0) \
		.map(cell_cords) \
		.filter(is_guard_in_that_direction)

	if viable_targets.size() > 0:
		viable_targets.sort_custom(distance_to_guard_sort)
		var index = randi() % roundi(viable_targets.size() * 0.25)
		set_target(viable_targets[index])

func escape() -> void:
	current_behaviour = Behaviour.ESCAPING
	var exit_points: Array = get_tree() \
		.get_nodes_in_group("ExitPoint") \
		.map(area_to_pos)

	if guard_visible:
		exit_points.sort_custom(angle_away_from_guard_sort)
		set_target(exit_points[0])
		return
	
	set_target(exit_points[randi() % exit_points.size()])

func cell_cords(tile: Vector2i) -> Vector2:
	return map.to_global(map.map_to_local(tile)) + Vector2(24, 24)

func is_guard_in_that_direction(pos: Vector2) -> bool:
	var angle = guard.global_position.angle_to(pos)
	return angle > -90 and angle < 90

func distance_to_guard_sort(a: Vector2, b: Vector2) -> bool:
	return distance_squared_to_guard(a) > distance_squared_to_guard(b)

func distance_squared_to_guard(pos: Vector2) -> float:
	return guard.global_position.distance_squared_to(pos)

func guard_detected(_body: Node2D) -> void:
	guard_visible = true

	if current_behaviour == Behaviour.FINDING_MONEY:
		run_away()

	if current_behaviour == Behaviour.ESCAPING:
		escape() # look for a different way out

func angle_away_from_guard(pos: Vector2) -> float:
	var vector_to_guard: Vector2 = guard.global_position - global_position
	var vector_to_pos: Vector2 = pos - global_position
	return absf(vector_to_guard.angle_to(vector_to_pos))

func angle_away_from_guard_sort(a: Vector2, b: Vector2) -> bool:
	return angle_away_from_guard(a) > angle_away_from_guard(b)

func guard_lost(_body: Node2D) -> void:
	guard_visible = false

func area_to_pos(area: Area2D) -> Vector2:
	return area.global_position
