extends Node
@onready var chest_puzzle_2: Node = $"../Chest Puzzle2"
@onready var chest_puzzle: Node = $"../Chest Puzzle"
@onready var ui_2: Control = $UI2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if chest_puzzle.is_open() or chest_puzzle_2.is_open():
		ui_2.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func check_ui_visibility() -> void:
	if chest_puzzle.is_open() or chest_puzzle_2.is_open():
		ui_2.hide()
