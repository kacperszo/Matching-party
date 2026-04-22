extends StaticBody2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

var is_player_near: bool = false

# 1. Add our own variable to track the dialogue state
var is_dialogue_active: bool = false 

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_near = true

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_near = false

func _unhandled_input(event: InputEvent) -> void:
	if is_player_near and event.is_action_pressed("interact"):
		# 2. Check our custom variable instead
		if not is_dialogue_active:
			is_dialogue_active = true
			DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
			
			# 3. Wait for the plugin to tell us the conversation is over
			await DialogueManager.dialogue_ended
			
			# 4. Allow the player to interact again
			is_dialogue_active = false
