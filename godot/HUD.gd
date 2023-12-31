extends Node

class_name HUD

const ninja_activity_base: String = "Ninja Activity: "
const money_remaining_base: String = "Money Remaining: £"
const game_over_base: String = "GAME OVER:

"

@onready var money_remaining: Label = $MoneyRemaining
@onready var ninja_activity: Label = $NinjaActivity
@onready var start_button: Button = $StartButton
@onready var instructions: Label = $Instructions
@onready var credits: RichTextLabel = $Credits
@onready var result: Label = $Result
@onready var back_to_menu: Button = $BackToMenu

@export var game: Game

func _ready() -> void:
	start_button.connect("button_up", game.play)
	back_to_menu.connect("button_up", game.start)

func set_ninja_activity(behaviour: MoneyFinder.Behaviour) -> void:
	$NinjaActivity.text = ninja_activity_base + behaviour_to_string(behaviour)

func set_money_remaining(remaining: int) -> void:
	money_remaining.text = money_remaining_base + str(remaining)

func behaviour_to_string(behaviour: MoneyFinder.Behaviour) -> String:
	if behaviour == MoneyFinder.Behaviour.RUNNING_AWAY:
		return "Running from Guard"
	if behaviour == MoneyFinder.Behaviour.ESCAPING:
		return "Escaping"
	return "Looking for Money"

func start() -> void:
	money_remaining.visible = false
	ninja_activity.visible = false
	start_button.visible = true
	instructions.visible = true
	credits.visible = true
	result.visible = false
	back_to_menu.visible = false

func play() -> void:
	money_remaining.visible = true
	ninja_activity.visible = true
	start_button.visible = false
	instructions.visible = false
	credits.visible = false
	result.visible = false
	back_to_menu.visible = false
	
func end(won: bool, remaining_money: int) -> void:
	set_money_remaining(remaining_money)
	if won:
		result.text = game_over_base + "You caught the Ninja, congratulations!"
	else:
		result.text = game_over_base + "The ninja escaped with £" + str(remaining_money)
	money_remaining.visible = false
	ninja_activity.visible = false
	start_button.visible = false
	instructions.visible = false
	credits.visible = false
	result.visible = true
	back_to_menu.visible = true
