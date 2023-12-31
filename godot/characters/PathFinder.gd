extends CharacterBody2D

class_name PathFinder

@export var speed: float = 300.0

@export var map: TileMap
@onready var agent: NavigationAgent2D = $NavigationAgent2D
var actual_velocity: Vector2 = Vector2.ZERO
var very_bad_cycle_counter: int = 3

func _ready() -> void:
	agent.set_navigation_map(map);
	agent.velocity_computed.connect(_on_velocity_computed)

func _physics_process(_delta: float) -> void:
	handle_move()

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	actual_velocity = safe_velocity
	move_and_slide()

func set_target(target: Vector2) -> void:
	agent.set_target_position(target)

func handle_move():
	if very_bad_cycle_counter > 0:
		very_bad_cycle_counter -= 1
		return
	
	if agent.is_navigation_finished():
		return
	
	var next_pos: Vector2 = agent.get_next_path_position()
	var current_pos: Vector2 = global_position
	var new_velocity: Vector2 = (next_pos - current_pos).normalized() * speed
	agent.set_velocity(new_velocity)
