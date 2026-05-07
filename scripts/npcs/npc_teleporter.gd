class_name TeleporterNPC
extends NPC

@export var teleport_interval_min: float = 3.0
@export var teleport_interval_max: float = 8.0

var _teleport_timer: float = 0.0
const TELEPORT_MIN_DISTANCE := 50.0
const TELEPORT_OCCUPIED_RADIUS := 40.0


func _ready() -> void:
	dialogue_start = "start_basic"
	super._ready()
	_reset_teleport_timer()


func _process(delta: float) -> void:
	_teleport_timer -= delta
	if _teleport_timer <= 0:
		teleport()


func teleport() -> void:
	var points = get_tree().get_nodes_in_group("teleport_points")
	if points.size() == 0:
		_reset_teleport_timer()
		return
	
	var valid_points = []
	for p in points:
		if not p is Node2D:
			continue
		var point := p as Node2D
		if point.global_position.distance_to(global_position) <= TELEPORT_MIN_DISTANCE:
			continue
		if _is_point_occupied(point.global_position):
			continue
		valid_points.append(p)
	
	if valid_points.size() == 0:
		_reset_teleport_timer()
		return
	
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


func _is_point_occupied(point_position: Vector2) -> bool:
	var scene := get_tree().current_scene
	if scene == null:
		return false

	for node in scene.find_children("*", "NPC", true, false):
		if node == self or not node is Node2D:
			continue
		if (node as Node2D).global_position.distance_to(point_position) < TELEPORT_OCCUPIED_RADIUS:
			return true

	return false
