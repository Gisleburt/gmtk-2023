extends Node2D

class_name Game

enum GameState { MENU, PLAYING, GAME_OVER }

const BASIC_BANK_LEVEL: Resource = preload("res://levels/BasicBank/BasicBank.tscn")

@onready var hud: HUD = $HUD

var money_remaining: int = 0
var game_state: GameState = GameState.MENU

func _ready() -> void:
	start()

func calc_money_remaining() -> void:
	var temp_money_remaining = get_tree() \
		.get_nodes_in_group("Money") \
		.map(money_value) \
		.reduce(sum)
	if temp_money_remaining != null:
		money_remaining = temp_money_remaining
	else:
		money_remaining = 0
	hud.set_money_remaining(money_remaining)

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
	
func start() -> void:
	#$CanvasModulate.visible = false
	load_map(BASIC_BANK_LEVEL)
	game_state = GameState.MENU
	calc_money_remaining()
	hud.start()
	get_tree().paused = false
	$Camera2D.enabled = true
	get_tree().get_nodes_in_group("PlayerCamera")[0].enabled = false

func play() -> void:
	#$CanvasModulate.visible = true
	load_map(BASIC_BANK_LEVEL)
	game_state = GameState.PLAYING
	hud.play()
	get_tree().paused = false
	$Camera2D.enabled = false
	get_tree().get_nodes_in_group("PlayerCamera")[0].enabled = true

func end(did_player_win: bool) -> void:
	#$CanvasModulate.visible = false
	game_state = GameState.GAME_OVER
	hud.end(did_player_win, money_remaining)
	get_tree().paused = true
	$Camera2D.enabled = false
	get_tree().get_nodes_in_group("Guard")[0].enabled = true

func guard_caught_ninja() -> void:
	if game_state == GameState.PLAYING:
		return end(true)

func ninja_escaped() -> void:
	if game_state == GameState.PLAYING:
		return end(false)
