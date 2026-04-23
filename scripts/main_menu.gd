extends Control

@export_file("*.tscn") var gameplay_scene_path: String = "res://scenes/test_level.tscn"

@onready var _play_button: TextureButton = $Ui/CenterStack/MenuCard/CardMargin/CardColumn/ActionRow/PlayAction/PlayButton
@onready var _how_to_play_button: TextureButton = $Ui/CenterStack/MenuCard/CardMargin/CardColumn/ActionRow/HowToPlayAction/HowToPlayButton
@onready var _quit_button: TextureButton = $Ui/CenterStack/MenuCard/CardMargin/CardColumn/ActionRow/QuitAction/QuitButton
@onready var _close_button: TextureButton = $HowToPlayPanel/PanelMargin/HowToPlayColumn/CloseRow/CloseButton
@onready var _modal_scrim: ColorRect = $ModalScrim
@onready var _how_to_play_panel: Control = $HowToPlayPanel
@onready var _character_left: Sprite2D = $Decor/CharacterLeft
@onready var _character_right: Sprite2D = $Decor/CharacterRight
@onready var _fruit_left: Sprite2D = $Decor/FruitLeft
@onready var _fruit_right: Sprite2D = $Decor/FruitRight
@onready var _start_flag: Sprite2D = $Decor/StartFlag

var _elapsed: float = 0.0
var _button_nodes: Array[TextureButton] = []
var _float_nodes: Array[Node2D] = []
var _float_origins: Array[Vector2] = []
var _float_amplitudes: Array[float] = []


func _ready() -> void:
	_button_nodes = [_play_button, _how_to_play_button, _quit_button, _close_button]
	_register_float_node(_character_left, 6.0)
	_register_float_node(_character_right, 5.0)
	_register_float_node(_fruit_left, 12.0)
	_register_float_node(_fruit_right, 10.0)
	_register_float_node(_start_flag, 4.0)
	_bind_buttons()
	_set_overlay_visible(false)
	_play_button.grab_focus()


func _process(delta: float) -> void:
	_elapsed += delta
	_animate_character_frames()
	_animate_fruit_frames()
	_animate_floaters()
	_update_button_feedback(delta)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_ESCAPE:
				if _how_to_play_panel.visible:
					_set_overlay_visible(false)
			KEY_ENTER, KEY_KP_ENTER:
				if not _how_to_play_panel.visible:
					_start_game()


func _register_float_node(node: Node2D, amplitude: float) -> void:
	_float_nodes.append(node)
	_float_origins.append(node.position)
	_float_amplitudes.append(amplitude)


func _bind_buttons() -> void:
	_play_button.pressed.connect(_start_game)
	_how_to_play_button.pressed.connect(_open_how_to_play)
	_quit_button.pressed.connect(_quit_game)
	_close_button.pressed.connect(_close_how_to_play)


func _animate_character_frames() -> void:
	var frame := int(_elapsed * 9.0)
	_character_left.frame = frame % _character_left.hframes
	_character_right.frame = frame % _character_right.hframes


func _animate_fruit_frames() -> void:
	var frame := int(_elapsed * 12.0)
	_fruit_left.frame = frame % _fruit_left.hframes
	_fruit_right.frame = (frame + 8) % _fruit_right.hframes


func _animate_floaters() -> void:
	for i in range(_float_nodes.size()):
		var node := _float_nodes[i]
		var origin := _float_origins[i]
		var amplitude := _float_amplitudes[i]
		node.position = origin + Vector2(0.0, sin(_elapsed * 1.4 + i * 0.75) * amplitude)


func _update_button_feedback(delta: float) -> void:
	for button in _button_nodes:
		var is_active := button.has_focus() or button.is_hovered()
		var target_scale := 1.12 if is_active else 1.0
		var target_alpha := 1.0 if is_active else 0.92
		button.scale = button.scale.lerp(Vector2.ONE * target_scale, delta * 10.0)
		var tint := button.modulate
		tint.a = move_toward(tint.a, target_alpha, delta * 5.0)
		button.modulate = tint


func _open_how_to_play() -> void:
	_set_overlay_visible(true)


func _close_how_to_play() -> void:
	_set_overlay_visible(false)


func _set_overlay_visible(is_visible: bool) -> void:
	_modal_scrim.visible = is_visible
	_how_to_play_panel.visible = is_visible

	if is_visible:
		_close_button.grab_focus()
	else:
		_play_button.grab_focus()


func _start_game() -> void:
	if gameplay_scene_path.is_empty():
		push_warning("Main menu has no gameplay scene configured.")
		return

	get_tree().change_scene_to_file(gameplay_scene_path)


func _quit_game() -> void:
	get_tree().quit()
