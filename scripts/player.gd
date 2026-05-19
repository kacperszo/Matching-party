extends CharacterBody2D

## Horizontal movement
@export var speed: float = 200.0
@export var acceleration: float = 1200.0
@export var friction: float = 1200.0

## Jump
@export var jump_velocity: float = -400.0
@export var gravity: float = 900.0
@export var fall_gravity_multiplier: float = 1.6  # faster fall for snappier feel

## Coyote time — how long after walking off a ledge the player can still jump
@export var coyote_time: float = 0.12

## Jump buffer — how early before landing a jump input is accepted
@export var jump_buffer_time: float = 0.12

## Radius in pixels within which interactables are detected
@export var interaction_radius: float = 60.0

var _coyote_timer: float = 0.0
var _jump_buffer_timer: float = 0.0
var _was_on_floor: bool = false
var _current_interactable: Interactable = null


func _ready() -> void:
	# Player on layer 2, collide only with world layer 1 (not NPCs on layer 4)
	collision_layer = 2
	collision_mask = 1
	_setup_interaction_area()


func _setup_interaction_area() -> void:
	var area := Area2D.new()
	area.collision_layer = 0
	area.collision_mask = 2
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = interaction_radius
	shape.shape = circle
	area.add_child(shape)
	add_child(area)
	area.area_entered.connect(_on_interactable_entered)
	area.area_exited.connect(_on_interactable_exited)


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_update_timers(delta)
	_handle_jump()
	_handle_horizontal(delta)
	_handle_interact()
	move_and_slide()
	_was_on_floor = is_on_floor()


func _handle_interact() -> void:
	if Input.is_action_just_pressed("interact") and _current_interactable != null:
		_current_interactable.interact(self)


func _on_interactable_entered(area: Area2D) -> void:
	if area is Interactable:
		_current_interactable = area as Interactable
		_current_interactable.show_prompt()


func _on_interactable_exited(area: Area2D) -> void:
	if area == _current_interactable:
		_current_interactable.hide_prompt()
		_current_interactable = null


func _apply_gravity(delta: float) -> void:
	if is_on_floor():
		return
	var g := gravity * (fall_gravity_multiplier if velocity.y > 0 else 1.0)
	velocity.y += g * delta


func _update_timers(delta: float) -> void:
	# Coyote: start counting down the moment the player leaves the floor
	if _was_on_floor and not is_on_floor():
		_coyote_timer = coyote_time
	elif is_on_floor():
		_coyote_timer = coyote_time  # reset while grounded so it's ready
	else:
		_coyote_timer = max(_coyote_timer - delta, 0.0)

	# Jump buffer: count down from the moment jump is pressed
	if Input.is_action_just_pressed("jump"):
		_jump_buffer_timer = jump_buffer_time
	else:
		_jump_buffer_timer = max(_jump_buffer_timer - delta, 0.0)


func _handle_jump() -> void:
	var can_jump := is_on_floor() or _coyote_timer > 0.0
	var wants_jump := _jump_buffer_timer > 0.0

	if can_jump and wants_jump:
		velocity.y = jump_velocity
		_coyote_timer = 0.0
		_jump_buffer_timer = 0.0

	# Variable jump height: releasing early cuts upward speed
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= 0.5


func _handle_horizontal(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0.0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
