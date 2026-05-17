extends Node2D

signal level_complete

@export var first_pair_number: int = 1
@export var fixed_seed: int = -1
@export var print_assignments: bool = true

var _total_pairs: int = 0
var _pairs_matched: int = 0


func _ready() -> void:
	_assign_random_hidden_values()


func _assign_random_hidden_values() -> void:
	var npcs := _find_npcs()

	if npcs.is_empty():
		push_warning("Level initializer found no NPCs to randomize.")
		return

	if npcs.size() % 2 != 0:
		push_error("Level initializer requires an even number of NPCs so every value has a pair.")
		return

	var pair_count := int(npcs.size() / 2)
	var values := _build_pair_values(pair_count)
	var rng := RandomNumberGenerator.new()
	if fixed_seed >= 0:
		rng.seed = fixed_seed
	else:
		rng.randomize()

	_shuffle_values(values, rng)

	for i in range(npcs.size()):
		npcs[i].hidden_value = values[i]

	_total_pairs = pair_count
	_pairs_matched = 0
	for npc in npcs:
		npc.match_succeeded.connect(_on_match_succeeded)

	if print_assignments:
		_print_assignments(npcs)


func _on_match_succeeded(_npc1: NPC, _npc2: NPC) -> void:
	_pairs_matched += 1
	if _pairs_matched >= _total_pairs:
		level_complete.emit()
		print("Level complete! All pairs matched.")


func _find_npcs() -> Array[NPC]:
	var result: Array[NPC] = []
	for node in find_children("*", "NPC", true, false):
		if node is NPC:
			result.append(node as NPC)
	return result


func _build_pair_values(pair_count: int) -> Array[int]:
	var values: Array[int] = []
	for i in range(pair_count):
		var value := first_pair_number + i
		values.append(value)
		values.append(value)
	return values


func _shuffle_values(values: Array[int], rng: RandomNumberGenerator) -> void:
	for i in range(values.size() - 1, 0, -1):
		var swap_index := rng.randi_range(0, i)
		var temp := values[i]
		values[i] = values[swap_index]
		values[swap_index] = temp


func _print_assignments(npcs: Array[NPC]) -> void:
	print("Randomized NPC number assignments:")
	for npc in npcs:
		print(" - ", npc.name, ": ", npc.hidden_value)
