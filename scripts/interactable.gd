class_name Interactable
extends Area2D

@export var prompt_text: String = "Interact"

var _prompt_label: Label

func _ready() -> void:
	collision_layer = 2
	collision_mask = 0
	_prompt_label = Label.new()
	_prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_prompt_label.add_theme_font_size_override("font_size", 14)
	add_child(_prompt_label)
	_prompt_label.hide()

func show_prompt() -> void:
	_prompt_label.text = "[E] " + prompt_text
	_prompt_label.position = Vector2(-_prompt_label.size.x / 2.0, -80)
	_prompt_label.show()

func hide_prompt() -> void:
	_prompt_label.hide()

## Override in subclasses to define interaction behaviour
func interact(_interactor: Node) -> void:
	pass
