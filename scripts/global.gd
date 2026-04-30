extends Node

var riddles: Array[Dictionary] = []
var insults: Array[String] = []
var patience_responses: Array[String] = []

func _ready() -> void:
	_load_riddles()
	_load_insults()
	_load_patience_responses()


func _load_riddles() -> void:
	var file_path = "res://data/riddles.json"
	if not FileAccess.file_exists(file_path):
		return

	var file = FileAccess.open(file_path, FileAccess.READ)
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	file.close()

	if error == OK:
		var raw_data = json.data
		if raw_data is Array:
			for riddle in raw_data:
				if riddle is Dictionary and riddle.has("correct_index"):
					riddle["correct_index"] = int(riddle["correct_index"])
			riddles.assign(raw_data)


func _load_insults() -> void:
	var file_path = "res://data/insults.json"
	if not FileAccess.file_exists(file_path):
		return

	var file = FileAccess.open(file_path, FileAccess.READ)
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	file.close()

	if error == OK and json.data is Array:
		insults.assign(json.data)


func _load_patience_responses() -> void:
	var file_path = "res://data/patience_responses.json"
	if not FileAccess.file_exists(file_path):
		return

	var file = FileAccess.open(file_path, FileAccess.READ)
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	file.close()

	if error == OK and json.data is Array:
		patience_responses.assign(json.data)


func get_random_riddle() -> Dictionary:
	if riddles.is_empty():
		return {
			"question": "What is 2 + 2?",
			"options": ["3", "4", "5", "6"],
			"correct_index": 1
		}
	return riddles.pick_random()


func get_random_insult() -> String:
	if insults.is_empty():
		return "Wrong! Try again."
	return insults.pick_random()


func get_random_patience_response() -> String:
	if patience_responses.is_empty():
		return "Leave me alone!"
	return patience_responses.pick_random()
