extends Control

@onready var _play_again_btn: Button = $VBox/PlayAgainButton
@onready var _menu_btn: Button = $VBox/MenuButton


func _ready() -> void:
	_play_again_btn.pressed.connect(_play_again)
	_menu_btn.pressed.connect(_main_menu)
	_play_again_btn.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			_play_again()


func _play_again() -> void:
	GameManager.start_game()


func _main_menu() -> void:
	GameManager.go_to_main_menu()
