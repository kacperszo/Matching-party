class_name JesterNPC
extends NPC

## Patience percentage below which the jester starts becoming unreliable (0.0 to 1.0)
@export var unreliable_threshold: float = 0.4

## The maximum probability of lying when patience is near zero
@export var max_lie_chance: float = 1.0

func _ready() -> void:
	dialogue_start = "start_basic"
	super._ready()
	# Jesters use the basic dialogue structure

func ask_number() -> int:
	if patience <= 0.0:
		answer_refused.emit()
		return -1
	
	var current_patience_ratio = patience / max_patience
	var value_to_reveal = hidden_value
	
	if current_patience_ratio <= unreliable_threshold:
		# Probability of lying increases as patience drops from threshold to 0.
		# At threshold, lie chance is small. At zero patience, it's max_lie_chance.
		var current_lie_chance = remap(current_patience_ratio, 0.0, unreliable_threshold, max_lie_chance, 0.6)
		if randf() < current_lie_chance:
			value_to_reveal = _get_incorrect_number()
			# The jester makes fun of the player by giving a wrong number.
	
	number_revealed.emit(value_to_reveal)
	return value_to_reveal

func _get_incorrect_number() -> int:
	return randi_range(0, 20)
