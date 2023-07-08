extends Node

@onready var map: TileMap = $TileMap
@onready var guard: NavigationAgent2D = $Guard/NavigationAgent2D

func _ready() -> void:
	guard.set_navigation_map(map.get_navigation_map(0))

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return
	guard.target_position = event.get_global_position()
