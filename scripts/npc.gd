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

@export var reveal_message_duration: float = 2.0

var patience: float
var is_following: bool = false

var _follow_target: Node2D = null
var _speech_label: Label
var _speech_timer: Timer


func _ready() -> void:
	prompt_text = "Ask"
	patience = max_patience
	super._ready()
	_setup_speech_label()


func _process(delta: float) -> void:
	if is_following and _follow_target != null:
		_tick_follow(delta)


# Called when the player presses interact while in range
func interact(_interactor: Node) -> void:
	var number := ask_number()
	if number == -1:
		_show_speech("I'm done talking.")
	else:
		_show_speech("My number is %d." % number)

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


func _setup_speech_label() -> void:
	_speech_label = Label.new()
	_speech_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_speech_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_speech_label.add_theme_font_size_override("font_size", 16)
	_speech_label.modulate = Color(1, 1, 1, 1)
	_speech_label.position = Vector2(-70, -112)
	_speech_label.size = Vector2(140, 48)
	_speech_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(_speech_label)
	_speech_label.hide()

	_speech_timer = Timer.new()
	_speech_timer.one_shot = true
	_speech_timer.timeout.connect(_hide_speech)
	add_child(_speech_timer)


func _show_speech(text: String) -> void:
	_speech_label.text = text
	_speech_label.show()
	_speech_timer.start(reveal_message_duration)


func _hide_speech() -> void:
	_speech_label.hide()
