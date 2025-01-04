extends GridContainer
class_name Scale

@export var target_weight: int
@onready var label: Label = $"../Label"
@onready var pause_menu: ColorRect = $".."
@export var game_manager: Node
@export var player: Node
@export var timeline_file: String = ""
@export var timeline_file2: String = ""
@export var mimic: AnimatedSprite2D
@export var logical_operator: String = "==" #default

var wrong_guess_count: int = 0
const MAX_WRONG_ANSWERS: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for slot in get_children():
		slot.connect("filled_changed", _on_slot_changed)
		
	if mimic:
		print("playing idle")
		mimic.play("idle")
	else:
		print("mimic animationplayer not found")


func _on_slot_changed() -> void:
	check_total_sts()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func check_total_sts() -> void:
	var total_sts = 0
	for slot in get_children():
		if slot.filled:
			total_sts += slot.get_STS()
	
	await get_tree().create_timer(3).timeout
	
	var is_correct: bool = false
	match logical_operator:
		"==":
			is_correct = total_sts == target_weight
		">=":
			is_correct = total_sts == target_weight
		"<=":
			is_correct = total_sts == target_weight
		"<":
			is_correct = total_sts == target_weight
		">":
			is_correct = total_sts == target_weight
		"!=":
			is_correct = total_sts == target_weight
		_:
			label.text = "Invalid Operator"
			print("Invalid logical operator: %s" % logical_operator)
			return
	
	if is_correct:
		handle_correct_answer()
	else:
		handle_wrong_answer()
		
func reset_question():
	for slot in get_children():
		if slot is Slot:
			slot.clear_slot()
		else:
			print("Non-slot child detected: %s" % slot.name)
		
		label.text = "Try Again"
		
func handle_wrong_answer():
	label.text = "Incorrect"
	await get_tree().create_timer(1.5).timeout
	pause_menu.hide()
	game_manager.decrease_health()
	mimic.play("reveal")
	reset_question()
	Dialogic.start(timeline_file)
	
func handle_correct_answer():
	label.text = "Correct!"
	await get_tree().create_timer(1.5).timeout
	pause_menu.hide()
	mimic.play("opened")
	Dialogic.start(timeline_file2)
			
			
	
		
	
		
	
