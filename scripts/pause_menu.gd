extends CanvasLayer

@onready var _scrim: ColorRect           = $Scrim
@onready var _panel: Control            = $Panel
@onready var _resume_btn: Button        = $Panel/VBox/ResumeButton
@onready var _restart_btn: Button       = $Panel/VBox/RestartButton
@onready var _menu_btn: Button          = $Panel/VBox/MenuButton
@onready var _music_slider: HSlider     = $Panel/VBox/MusicRow/MusicSlider
@onready var _sfx_slider: HSlider       = $Panel/VBox/SFXRow/SFXSlider


func _ready() -> void:
	_scrim.visible = false
	_panel.visible = false
	_resume_btn.pressed.connect(resume)
	_restart_btn.pressed.connect(_restart)
	_menu_btn.pressed.connect(_go_menu)
	_music_slider.value_changed.connect(_on_music_slider)
	_sfx_slider.value_changed.connect(_on_sfx_slider)
	_music_slider.value = SoundManager.get_music_volume()
	_sfx_slider.value  = SoundManager.get_sfx_volume()


func _unhandled_input(event: InputEvent) -> void:
	if _panel.visible and event.is_action_pressed("pause") and not event.is_echo():
		resume()
		get_viewport().set_input_as_handled()


func show_pause() -> void:
	_scrim.visible = true
	_panel.visible = true
	get_tree().paused = true
	_resume_btn.grab_focus()


func resume() -> void:
	_scrim.visible = false
	_panel.visible = false
	get_tree().paused = false


func _restart() -> void:
	get_tree().paused = false
	GameManager.restart_level()


func _go_menu() -> void:
	get_tree().paused = false
	GameManager.go_to_main_menu()


func _on_music_slider(value: float) -> void:
	SoundManager.set_music_volume(value)


func _on_sfx_slider(value: float) -> void:
	SoundManager.set_sfx_volume(value)
