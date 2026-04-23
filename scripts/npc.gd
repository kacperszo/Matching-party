class_name NPC
extends Interactable

signal patience_changed(new_patience: float, max_patience: float)
signal patience_depleted
signal number_revealed(number: int)
signal answer_refused

## Number hidden from the player — revealed only when asked
@export var hidden_value: int = 0

## Total patience pool; each interaction costs patience_per_ask
@export var max_patience: float = 5.0
@export var patience_per_ask: float = 1.0

## How fast patience drains per second while the NPC is following the player
@export var follow_drain_rate: float = 0.1

@export var dialogue_resource: DialogueResource        
@export var dialogue_start: String = "start"                                                                                                                 
														 
var _is_dialogue_active: bool = false

var patience: float
var is_following: bool = false

var _follow_target: Node2D = null


func _ready() -> void:
	prompt_text = "Talk"
	patience = max_patience
	super._ready()


func _process(delta: float) -> void:
	if is_following and _follow_target != null:
		_tick_follow(delta)


# Called when the player presses interact while in range
func interact(_interactor: Node) -> void:                                                                                                                    
	if dialogue_resource == null or _is_dialogue_active:                                                                                                     
		return                                          
	_is_dialogue_active = true                                                                                                                               
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
	await DialogueManager.dialogue_ended                                    
	_is_dialogue_active = false

# Returns the hidden value and costs patience.
# Returns -1 and emits answer_refused when patience is depleted.
func ask_number() -> int:
	if patience <= 0.0:
		answer_refused.emit()
		return -1

	_decrease_patience(patience_per_ask)
	number_revealed.emit(hidden_value)
	return hidden_value


func ask_to_follow(target: Node2D) -> void:
	is_following = true
	_follow_target = target


func stop_following() -> void:
	is_following = false
	_follow_target = null


func restore_patience(amount: float) -> void:
	patience = minf(patience + amount, max_patience)
	patience_changed.emit(patience, max_patience)


func _decrease_patience(amount: float) -> void:
	patience = maxf(patience - amount, 0.0)
	patience_changed.emit(patience, max_patience)
	if patience <= 0.0:
		patience_depleted.emit()


func _tick_follow(delta: float) -> void:
	_decrease_patience(follow_drain_rate * delta)
	# Placeholder — movement will be implemented with CharacterBody2D refactor
	global_position = global_position.lerp(_follow_target.global_position + Vector2(40, 0), delta * 3.0)
