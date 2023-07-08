extends CharacterBody2D

const SPEED = 300.0

@onready var map: TileMap = $%TileMap
@onready var agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	agent.set_navigation_map(map);
	agent.velocity_computed.connect(_on_velocity_computed)

func set_target(target: Vector2) -> void:
	agent.set_target_position(target)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_LEFT:
				set_target(get_global_mouse_position())

func _physics_process(_delta: float) -> void:
	handle_move()

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()

func handle_move():
	if agent.is_navigation_finished():
		return
	
	var next_pos: Vector2 = agent.get_next_path_position()
	var current_pos: Vector2 = global_position
	var new_velocity: Vector2 = (next_pos - current_pos).normalized() * SPEED
	agent.set_velocity(new_velocity)
