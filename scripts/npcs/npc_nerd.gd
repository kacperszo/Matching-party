class_name NerdNPC
extends NPC

## Whether the player has already answered this NPC's riddle
@export var riddle_solved: bool = false

# Current riddle data
var riddle_question: String = ""
var riddle_options: Array = []
var riddle_correct_index: int = -1
var selected_index: int = -1

func _ready() -> void:
	dialogue_start = "start_nerd"
	super._ready()
	
	# Assign a random riddle
	var current_riddle = Global.get_random_riddle()
	riddle_question = current_riddle.get("question", "No question")
	riddle_options = current_riddle.get("options", [])
	riddle_correct_index = int(current_riddle.get("correct_index", -1))


func check_answer(index: int) -> bool:
	if index == riddle_correct_index:
		riddle_solved = true
		return true
	return false


func get_insult() -> String:
	return Global.get_random_insult()
