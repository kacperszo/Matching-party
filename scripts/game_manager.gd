extends Node

const LEVELS: Array[String] = [
	"res://scenes/level0.tscn",
	"res://scenes/level1.tscn",
	"res://scenes/level2.tscn",
	"res://scenes/level3.tscn",
]
const YOU_WON_SCENE: String  = "res://scenes/you_won.tscn"
const MAIN_MENU_SCENE: String = "res://scenes/main_menu.tscn"

const LEVEL_NAMES: Array[String] = [
	"Tutorial",
	"Level 1",
	"Level 2",
	"Level 3",
]

var _current_level_index: int = 0
var _is_in_gameplay: bool = false
var _pause_menu: Node = null


func _ready() -> void:
	var pm_scene := load("res://scenes/pause_menu.tscn") as PackedScene
	if pm_scene:
		_pause_menu = pm_scene.instantiate()
		get_tree().root.call_deferred("add_child", _pause_menu)


func _unhandled_input(event: InputEvent) -> void:
	if not _is_in_gameplay:
		return
	if event.is_action_pressed("pause") and not event.is_echo():
		if get_tree().paused:
			_pause_menu.resume()
		else:
			_pause_menu.show_pause()
		get_viewport().set_input_as_handled()


func start_game() -> void:
	_current_level_index = 0
	_is_in_gameplay = true
	SoundManager.play_music("gameplay")
	get_tree().change_scene_to_file(LEVELS[0])


func on_level_complete() -> void:
	SoundManager.play_sfx("level_complete")
	_current_level_index += 1
	if _current_level_index >= LEVELS.size():
		_is_in_gameplay = false
		SoundManager.play_music("victory")
		get_tree().change_scene_to_file(YOU_WON_SCENE)
	else:
		get_tree().change_scene_to_file(LEVELS[_current_level_index])


func restart_level() -> void:
	get_tree().change_scene_to_file(LEVELS[_current_level_index])


func go_to_main_menu() -> void:
	_is_in_gameplay = false
	SoundManager.play_music("menu")
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)


func current_level_name() -> String:
	if _current_level_index < LEVEL_NAMES.size():
		return LEVEL_NAMES[_current_level_index]
	return "Level %d" % _current_level_index
