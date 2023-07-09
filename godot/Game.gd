extends Node2D

class_name Game

enum GameState { MENU, PLAYING, GAME_OVER }

const BASIC_BANK_LEVEL: Resource = preload("res://levels/BasicBank/BasicBank.tscn")

@onready var hud: HUD = $HUD

var money_remaining: int = 0
var game_state: GameState = GameState.MENU

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	money_remaining = get_tree() \
		.get_nodes_in_group("Money") \
		.map(money_value) \
		.reduce(sum)

func money_value(money: Node) -> int:
	if money.has_method("get_value"):
		return money.get_value()
	return 0

func sum(a: int, b: int) -> int:
	return a + b

func load_map(map: Resource) -> void:
	var new_map = map.instantiate()
	remove_child($Map)
	new_map.name = "Map"
	add_child(new_map)

func play() -> void:
	load_map(BASIC_BANK_LEVEL)
	game_state = GameState.PLAYING
	hud.set_state(game_state)
	
func start() -> void:
	load_map(BASIC_BANK_LEVEL)
	game_state = GameState.MENU
	hud.set_state(game_state)

func end(did_player_win: bool) -> void:
	game_state = GameState.GAME_OVER
	hud.set_state(game_state)

