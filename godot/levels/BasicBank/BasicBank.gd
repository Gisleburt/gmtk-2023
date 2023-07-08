extends Node2D

@onready var guard: CharacterBody2D = $Guard

var mouse_button_left_held = false;

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			mouse_button_left_held = event.is_pressed()


func _process(delta: float) -> void:
	if mouse_button_left_held:
		guard.set_target(get_global_mouse_position())

