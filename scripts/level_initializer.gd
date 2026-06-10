extends Node2D

signal level_complete
signal pair_matched(matched: int, total: int)

@export var first_pair_number: int = 1
@export var fixed_seed: int = -1
@export var print_assignments: bool = true
## Y coordinate below which the player or an NPC is considered fallen off the map
@export var death_zone_y: float = 800.0

var _total_pairs: int = 0
var _pairs_matched: int = 0
var _player: CharacterBody2D = null
var _restarting: bool = false


func _ready() -> void:
	_assign_random_hidden_values()
	_inject_hud()
	_player = find_child("Player", true, false) as CharacterBody2D


func _process(_delta: float) -> void:
	if _restarting:
		return
	if _player != null and _player.global_position.y > death_zone_y:
		_trigger_fall_restart()
		return
	for node in get_tree().get_nodes_in_group("npcs"):
		if node is NPC and node.global_position.y > death_zone_y:
			_trigger_fall_restart()
			return


func _trigger_fall_restart() -> void:
	_restarting = true
	GameManager.restart_level()


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
	pair_matched.emit(_pairs_matched, _total_pairs)
	if _pairs_matched >= _total_pairs:
		level_complete.emit()
		GameManager.on_level_complete()


func _inject_hud() -> void:
	var hud_scene := load("res://scenes/hud.tscn") as PackedScene
	if hud_scene == null:
		return
	var hud := hud_scene.instantiate()
	add_child(hud)
	hud.setup(self, GameManager.current_level_name())


func get_total_pairs() -> int:
	return _total_pairs


func _find_npcs() -> Array[NPC]:
	var result: Array[NPC] = []
	for node in find_children("*", "NPC", true, false):
		if node is NPC and node.is_in_group("npcs"):
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
