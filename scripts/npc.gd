class_name NPC
extends CharacterBody2D

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
@export var follow_speed: float = 140.0
@export var follow_acceleration: float = 700.0
@export var follow_friction: float = 900.0
@export var gravity: float = 900.0
@export var prompt_text: String = "Talk"

@export var dialogue_resource: DialogueResource        
@export var dialogue_start: String = "start"                                                                                                                 
														 
var _is_dialogue_active: bool = false

var patience: float
var is_following: bool = false

var _follow_target: Node2D = null
@onready var _interaction_area: NPCInteractionArea = $InteractionArea


func _ready() -> void:
	patience = max_patience
	_sync_prompt()


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_update_follow_velocity(delta)
	move_and_slide()


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
	prompt_text = "Wait"
	_sync_prompt()


func stop_following() -> void:
	is_following = false
	_follow_target = null
	prompt_text = "Talk"
	_sync_prompt()


func restore_patience(amount: float) -> void:
	patience = minf(patience + amount, max_patience)
	patience_changed.emit(patience, max_patience)


func _decrease_patience(amount: float) -> void:
	patience = maxf(patience - amount, 0.0)
	patience_changed.emit(patience, max_patience)
	if patience <= 0.0:
		patience_depleted.emit()


func _update_follow_velocity(delta: float) -> void:
	if is_following and is_instance_valid(_follow_target):
		_decrease_patience(follow_drain_rate * delta)
		var target_x := _follow_target.global_position.x + 40.0
		var distance_x := target_x - global_position.x
		if absf(distance_x) > 6.0:
			velocity.x = move_toward(velocity.x, sign(distance_x) * follow_speed, follow_acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0.0, follow_friction * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, follow_friction * delta)


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	elif velocity.y > 0.0:
		velocity.y = 0.0


func _sync_prompt() -> void:
	if _interaction_area != null:
		_interaction_area.sync_prompt_from_npc()
