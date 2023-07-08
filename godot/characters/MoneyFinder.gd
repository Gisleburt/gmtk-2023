extends PathFinder

func _ready() -> void:
	super()
	set_next_money()

func _process(_delta: float) -> void:
	if agent.is_navigation_finished():
		set_next_money()

func set_next_money() -> void:
	var money: Array = get_tree().get_nodes_in_group("Money");
	if money.size() > 0:
		set_target(money[randi() % money.size()].global_position)

