class_name NPC
extends CharacterBody2D

signal patience_changed(new_patience: float, max_patience: float)
signal patience_depleted
signal number_revealed(number: int)
signal answer_refused

## Name shown in dialogue
@export var npc_name: String = "Party NPC"

## Whether the player has already answered this NPC's riddle
@export var is_riddle_solved: bool = false

# Current riddle data
var riddle_question: String = ""
var riddle_options: Array = []
var riddle_correct_index: int = -1
var selected_index: int = -1

## Number hidden from the player — revealed only when asked
@export var hidden_value: int = 0
@export var riddle_solved: bool = false

## Total patience pool; each interaction costs patience_per_ask
@export var max_patience: float = 5.0
@export var patience_per_ask: float = 1.0

## Physics tuning for the grounded NPC body
@export var gravity: float = 900.0
@export var prompt_text: String = "Talk"

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

var _is_dialogue_active: bool = false

var patience: float
var patience_bar: ProgressBar

@onready var _interaction_area: NPCInteractionArea = $InteractionArea


func _ready() -> void:
	patience = max_patience
	_setup_patience_bar()
	_sync_prompt()

	# Assign a random riddle
	var current_riddle = Global.get_random_riddle()
	riddle_question = current_riddle.get("question", "No question")

	riddle_options = current_riddle.get("options", [])
	riddle_correct_index = int(current_riddle.get("correct_index", -1))


func _setup_patience_bar() -> void:
	patience_bar = ProgressBar.new()
	add_child(patience_bar)

	# Basic styling and positioning
	patience_bar.show_percentage = false
	patience_bar.custom_minimum_size = Vector2(40, 6)
	patience_bar.size = patience_bar.custom_minimum_size
	patience_bar.position = Vector2(-20, -45) # Above the NPC

	patience_bar.max_value = max_patience
	patience_bar.value = patience

	# Optional: Make it look like a small bar
	var style_bg = StyleBoxFlat.new()
	style_bg.bg_color = Color(0.2, 0.2, 0.2, 0.8)
	patience_bar.add_theme_stylebox_override("background", style_bg)

	var style_fg = StyleBoxFlat.new()
	style_fg.bg_color = Color(0.1, 0.8, 0.1, 0.9)
	patience_bar.add_theme_stylebox_override("fill", style_fg)


func _physics_process(delta: float) -> void:

	_apply_gravity(delta)
	move_and_slide()


# Called when the player presses interact while in range
func interact(_interactor: Node) -> void:                                                                                                                    
	if dialogue_resource == null or _is_dialogue_active:                                                                                                     
		return                                          
	_is_dialogue_active = true                                                                                                                               
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start, [self])
	await DialogueManager.dialogue_ended                                    
	_is_dialogue_active = false
	_decrease_patience(patience_per_ask)

# Returns the hidden value and costs patience.
# Returns -1 and emits answer_refused when patience is depleted.
func ask_number() -> int:
	if patience <= 0.0:
		answer_refused.emit()
		return -1

	number_revealed.emit(hidden_value)
	return hidden_value


func get_number_dialogue_text() -> String:
	var revealed_number := ask_number()
	if revealed_number == -1:
		return get_patience_depleted_response()

	return "My number is %d." % revealed_number


func get_patience_depleted_response() -> String:
	return Global.get_random_patience_response()

func check_answer(index: int) -> bool:
	if index == riddle_correct_index:
		is_riddle_solved = true
		return true
	return false


func get_insult() -> String:
	return Global.get_random_insult()


func restore_patience(amount: float) -> void:
	patience = minf(patience + amount, max_patience)
	if patience_bar:
		patience_bar.value = patience
	patience_changed.emit(patience, max_patience)


func _decrease_patience(amount: float) -> void:
	patience = maxf(patience - amount, 0.0)
	if patience_bar:
		patience_bar.value = patience
	patience_changed.emit(patience, max_patience)
	if patience <= 0.0:
		patience_depleted.emit()


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	elif velocity.y > 0.0:
		velocity.y = 0.0


func _sync_prompt() -> void:
	if _interaction_area != null:
		_interaction_area.sync_prompt_from_npc()
