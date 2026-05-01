class_name BasicNPC
extends NPC

func _ready() -> void:
	super._ready()
	if dialogue_start == "start":
		dialogue_start = "basic_start"
