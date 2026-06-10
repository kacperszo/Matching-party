extends Node

const _BASE := "res://assets/audio/kenney_interface-sounds/Audio/"

const SFX_PATHS: Dictionary = {
	"match_success":    _BASE + "confirmation_002.ogg",
	"match_fail":       _BASE + "error_002.ogg",
	"npc_follow":       _BASE + "select_001.ogg",
	"patience_depleted":_BASE + "scratch_001.ogg",
	"button_click":     _BASE + "click_001.ogg",
	"level_complete":   _BASE + "confirmation_004.ogg",
	"jump":             _BASE + "bong_001.ogg",
}

const _MUSIC_TRACK := "res://assets/audio/brackeys_platformer_assets/music/time_for_adventure.mp3"

const MUSIC_PATHS: Dictionary = {
	"menu":     _MUSIC_TRACK,
	"gameplay": _MUSIC_TRACK,
	"victory":  _MUSIC_TRACK,
}

const SFX_POOL_SIZE := 4

var _music_player: AudioStreamPlayer
var _sfx_pool: Array[AudioStreamPlayer] = []
var _sfx_index: int = 0

var _music_bus: int = -1
var _sfx_bus: int = -1


func _ready() -> void:
	_setup_buses()
	_setup_players()


func _setup_buses() -> void:
	if AudioServer.get_bus_index("Music") == -1:
		AudioServer.add_bus()
		var idx := AudioServer.get_bus_count() - 1
		AudioServer.set_bus_name(idx, "Music")
		AudioServer.set_bus_send(idx, "Master")
	if AudioServer.get_bus_index("SFX") == -1:
		AudioServer.add_bus()
		var idx := AudioServer.get_bus_count() - 1
		AudioServer.set_bus_name(idx, "SFX")
		AudioServer.set_bus_send(idx, "Master")
	_music_bus = AudioServer.get_bus_index("Music")
	_sfx_bus   = AudioServer.get_bus_index("SFX")


func _setup_players() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Music"
	_music_player.autoplay = false
	add_child(_music_player)

	for i in SFX_POOL_SIZE:
		var p := AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		_sfx_pool.append(p)


func play_sfx(name: String) -> void:
	if not SFX_PATHS.has(name):
		return
	var path: String = SFX_PATHS[name]
	if not ResourceLoader.exists(path):
		return
	var player := _sfx_pool[_sfx_index % SFX_POOL_SIZE]
	_sfx_index += 1
	player.stream = load(path)
	player.play()


func play_music(name: String) -> void:
	if not MUSIC_PATHS.has(name):
		return
	var path: String = MUSIC_PATHS[name]
	if not ResourceLoader.exists(path):
		return
	var stream := load(path) as AudioStream
	if stream is AudioStreamMP3:
		(stream as AudioStreamMP3).loop = true
	if _music_player.playing:
		return
	_music_player.stream = stream
	_music_player.play()


func stop_music() -> void:
	_music_player.stop()


func set_music_volume(volume_linear: float) -> void:
	if _music_bus >= 0:
		AudioServer.set_bus_volume_db(_music_bus, linear_to_db(volume_linear))


func set_sfx_volume(volume_linear: float) -> void:
	if _sfx_bus >= 0:
		AudioServer.set_bus_volume_db(_sfx_bus, linear_to_db(volume_linear))


func get_music_volume() -> float:
	if _music_bus < 0:
		return 1.0
	return db_to_linear(AudioServer.get_bus_volume_db(_music_bus))


func get_sfx_volume() -> float:
	if _sfx_bus < 0:
		return 1.0
	return db_to_linear(AudioServer.get_bus_volume_db(_sfx_bus))
