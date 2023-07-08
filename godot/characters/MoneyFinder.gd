extends PathFinder

func _ready() -> void:
	super()
	set_next_money()

func set_next_money() -> void:
	var money: Array = get_tree().get_nodes_in_group("Money");
	set_target(money[randi() % money.size()].global_position)
