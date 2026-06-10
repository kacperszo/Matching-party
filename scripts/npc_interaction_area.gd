class_name NPCInteractionArea
extends Interactable

@onready var _npc: NPC = get_parent() as NPC


func _ready() -> void:
	super._ready()
	_sync_prompt()
	if _npc != null and _npc.auto_interact:
		collision_mask = 2  # detect player CharacterBody2D (layer 2)
		body_entered.connect(_on_body_entered_auto)


func _on_body_entered_auto(body: Node) -> void:
	if _npc != null and not _npc._is_dialogue_active and not _npc._is_matched:
		_npc.interact(body)


func interact(interactor: Node) -> void:
	if _npc != null:
		_npc.interact(interactor)


func sync_prompt_from_npc() -> void:
	_sync_prompt()


func _sync_prompt() -> void:
	if _npc == null:
		return

	prompt_text = _npc.prompt_text
	refresh_prompt()
