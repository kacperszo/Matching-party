extends CanvasLayer

@onready var _pair_label: Label = $Control/TopBar/PairCounter
@onready var _level_label: Label = $Control/TopBar/LevelLabel


func setup(initializer: Node, level_name: String) -> void:
	_level_label.text = level_name
	_pair_label.text = "0 / %d matches" % initializer.get_total_pairs()
	initializer.pair_matched.connect(_on_pair_matched)


func _on_pair_matched(matched: int, total: int) -> void:
	_pair_label.text = "%d / %d matches" % [matched, total]
