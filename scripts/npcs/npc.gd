class_name NPC
extends CharacterBody2D

signal patience_changed(new_patience: float, max_patience: float)
signal patience_depleted
signal number_revealed(number: int)
signal answer_refused
signal match_succeeded(npc1: NPC, npc2: NPC)

## Name shown in dialogue
@export var npc_name: String = "Party NPC"

## Number hidden from the player — revealed only when asked
@export var hidden_value: int = 0

## Total patience pool; each interaction costs patience_per_ask
@export var max_patience: float = 5.0
@export var patience_per_ask: float = 1.0

## Following behaviour
@export var follow_speed: float = 80.0
@export var follow_stop_distance: float = 50.0
## Patience lost per second while following
@export var follow_patience_drain: float = 0.1
## Patience slowly recovered per second when not following
@export var patience_regen_rate: float = 0.04

## Physics tuning for the grounded NPC body
@export var gravity: float = 900.0
@export var jump_velocity: float = -380.0
## How many px above the NPC the player must be to trigger a jump
@export var jump_height_threshold: float = 60.0
@export var prompt_text: String = "Talk"

@export var dialogue_resource: DialogueResource
var dialogue_start: String = "start_basic"

var _is_dialogue_active: bool = false
var current_balloon: Node = null

var patience: float
var patience_bar: ProgressBar

## Following state
var is_following: bool = false
var follow_target: Node2D = null
var _interactor: Node = null
var _jump_cooldown: float = 0.0
var _is_matched: bool = false

@onready var _interaction_area: NPCInteractionArea = $InteractionArea


func _ready() -> void:
	patience = max_patience
	# NPCs on layer 3 (value 4), collide only with world layer 1
	collision_layer = 4
	collision_mask = 1
	add_to_group("npcs")
	_setup_patience_bar()
	_sync_prompt()


func _setup_patience_bar() -> void:
	patience_bar = ProgressBar.new()
	add_child(patience_bar)

	patience_bar.show_percentage = false
	patience_bar.custom_minimum_size = Vector2(40, 6)
	patience_bar.size = patience_bar.custom_minimum_size
	patience_bar.position = Vector2(-20, -45)

	patience_bar.max_value = max_patience
	patience_bar.value = patience

	var style_bg = StyleBoxFlat.new()
	style_bg.bg_color = Color(0.2, 0.2, 0.2, 0.8)
	patience_bar.add_theme_stylebox_override("background", style_bg)

	var style_fg = StyleBoxFlat.new()
	style_fg.bg_color = Color(0.1, 0.8, 0.1, 0.9)
	patience_bar.add_theme_stylebox_override("fill", style_fg)


func _physics_process(delta: float) -> void:
	if _is_matched:
		return
	_apply_gravity(delta)
	if is_following and follow_target != null:
		_handle_following(delta)
	else:
		_regen_patience(delta)
	move_and_slide()


func _handle_following(delta: float) -> void:
	var diff_x := follow_target.global_position.x - global_position.x
	var dist := absf(diff_x)
	if dist > follow_stop_distance:
		velocity.x = signf(diff_x) * follow_speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, 400.0 * delta)

	_jump_cooldown = maxf(_jump_cooldown - delta, 0.0)
	var height_diff := global_position.y - follow_target.global_position.y
	if is_on_floor() and _jump_cooldown <= 0.0 and height_diff > jump_height_threshold:
		velocity.y = jump_velocity
		_jump_cooldown = 0.8

	_decrease_patience(follow_patience_drain * delta)
	if patience <= 0.0:
		stop_following()


func _regen_patience(delta: float) -> void:
	if patience >= max_patience:
		return
	patience = minf(patience + patience_regen_rate * delta, max_patience)
	if patience_bar:
		patience_bar.value = patience


# Called when the player presses interact while in range
func interact(interactor: Node) -> void:
	if _is_matched or dialogue_resource == null or _is_dialogue_active:
		return
	_interactor = interactor
	_is_dialogue_active = true
	current_balloon = DialogueManager.show_dialogue_balloon(dialogue_resource, get_dialogue_start(), [self])
	await DialogueManager.dialogue_ended
	_is_dialogue_active = false
	current_balloon = null
	if not _is_matched:
		_decrease_patience(patience_per_ask)


func get_dialogue_start() -> String:
	return dialogue_start


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


func restore_patience(amount: float) -> void:
	patience = minf(patience + amount, max_patience)
	if patience_bar:
		patience_bar.value = patience
	patience_changed.emit(patience, max_patience)


# --- Following ---

func start_following() -> void:
	if _interactor == null:
		return
	# Only one follower at a time — stop the previous one first
	for node in get_tree().get_nodes_in_group("following_npcs"):
		if node != self and node is NPC:
			(node as NPC).stop_following()
	is_following = true
	follow_target = _interactor as Node2D
	add_to_group("following_npcs")
	_sync_prompt()


func stop_following() -> void:
	is_following = false
	follow_target = null
	if is_in_group("following_npcs"):
		remove_from_group("following_npcs")
	_sync_prompt()


# True when there is a follower in the scene and this NPC is not the one following.
# Used to decide whether to show the Match! dialogue option.
func can_attempt_match() -> bool:
	if is_following:
		return false
	for node in get_tree().get_nodes_in_group("following_npcs"):
		if node != self and node is NPC:
			return true
	return false


# Tries to match this NPC with the current follower.
# Success: both NPCs deactivate and match_succeeded is emitted.
# Fail: all NPCs lose patience (wrong guess penalty).
func try_match() -> void:
	var follower: NPC = null
	for node in get_tree().get_nodes_in_group("following_npcs"):
		if node != self and node is NPC:
			follower = node as NPC
			break

	if follower == null:
		return

	if follower.hidden_value == hidden_value:
		follower.stop_following()
		match_succeeded.emit(self, follower)
		_deactivate()
		follower._deactivate()
	else:
		_penalize_all_npcs(1.0)


func _penalize_all_npcs(amount: float) -> void:
	for node in get_tree().get_nodes_in_group("npcs"):
		if node is NPC and not (node as NPC)._is_matched:
			(node as NPC)._decrease_patience(amount)


func _deactivate() -> void:
	_is_matched = true
	visible = false
	if patience_bar:
		patience_bar.visible = false
	if _interaction_area:
		_interaction_area.set_deferred("monitoring", false)
		_interaction_area.set_deferred("monitorable", false)


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
