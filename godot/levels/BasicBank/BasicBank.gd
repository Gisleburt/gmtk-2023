extends Node2D

@onready var guard: CharacterBody2D = $Guard

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_LEFT:
				guard.set_target(get_global_mouse_position())
