class_name NPCInteractionArea
extends Interactable

@onready var _npc: NPC = get_parent() as NPC


func _ready() -> void:
	super._ready()
	_sync_prompt()


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
