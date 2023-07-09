extends Area2D

@export var value: int = 100

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(node: Node2D) -> void:
	if node.name == "Ninja":
		queue_free()

func get_value() -> int:
	return value
