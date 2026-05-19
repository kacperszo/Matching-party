class_name TeleporterNPC
extends NPC

@export var teleport_interval_min: float = 25.0
@export var teleport_interval_max: float = 40.0

var _teleport_timer: float = 0.0


func _ready() -> void:
	dialogue_start = "start_basic"
	super._ready()
	_reset_teleport_timer()


func _process(delta: float) -> void:
	_teleport_timer -= delta
	if _teleport_timer <= 0:
		teleport()


func teleport() -> void:
	if is_following:
		_reset_teleport_timer()
		return
	var points = get_tree().get_nodes_in_group("teleport_points")
	if points.size() == 0:
		_reset_teleport_timer()
		return
	
	# Filter out points that are too close to current position
	var valid_points = []
	for p in points:
		if p is Node2D and p.global_position.distance_to(global_position) > 50:
			valid_points.append(p)
	
	if valid_points.size() == 0:
		# If no other points, just use any point but the current one if possible
		valid_points = points
	
	var target_point = valid_points.pick_random()
	
	# Interrupt dialogue if active
	if _is_dialogue_active and is_instance_valid(current_balloon):
		current_balloon.queue_free()
		# Emitting this ensures the interact() coroutine in npc.gd resumes and completes.
		DialogueManager.dialogue_ended.emit(dialogue_resource)
		_is_dialogue_active = false
		current_balloon = null
	
	global_position = target_point.global_position
	_reset_teleport_timer()


func _reset_teleport_timer() -> void:
	_teleport_timer = randf_range(teleport_interval_min, teleport_interval_max)
