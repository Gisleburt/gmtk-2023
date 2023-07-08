extends CharacterBody2D

const SPEED = 300.0

@onready var map: TileMap = $%TileMap
@onready var agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	agent.set_navigation_map(map);

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_LEFT:
				agent.target_location = get_global_mouse_position()

func _physics_process(_delta: float) -> void:
	if agent.distance_to_target() > agent.target_desired_distance:
		var dir = agent.get_next_path_position() - position
		var distance = dir.length();
		velocity = dir.normalized() * SPEED
		move_and_slide()
	else:
		velocity = Vector2()
