extends GridContainer
class_name Scale

@export var target_weight: int
@export var game_manager: Node
@export var player: Node
@export var timeline_file: String = ""
@export var timeline_file2: String = ""
@export var mimic: AnimatedSprite2D
@export var logical_operator: String = "==" #default
@export var expected_item_id: int = -1 #set in editor, base it on database.JSON
@export var interactable_node : Node
@onready var clues: Area2D = $Clues
@onready var collision_shape_2d: CollisionShape2D = $Clues/CollisionShape2D
@export var item_weight: int
@export var clue_hint: String = ""
@onready var pause_menu: Control = $".."
@onready var label: Label = $"../PauseMenu/Label"
@export var ui: Node


var button_presse: bool = false
var opened: bool = false
var wrong_guess_count: int = 0
const MAX_WRONG_ANSWERS: int = 3
var is_ready_to_check: bool = false
var total_sts: int = 0
var all_items_are_coins: bool = true
var is_confirming: bool = false
var button_should_close: bool = false



signal correct_answer_handled

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = clue_hint
	for slot in get_children():
		slot.connect("filled_changed", _on_slot_changed)
		
	if mimic:
		print("playing idle")
		mimic.play("idle")
	else:
		print("mimic animationplayer not found")
		
	if is_instance_valid(clues):
		clues.hide()
		collision_shape_2d.disabled = true


func _on_slot_changed() -> void:
	is_ready_to_check = false
	label.text = "Arrange the items and press check"
	

		
func confirm_slots():
	if is_confirming:
		return
	is_confirming = true
	
	total_sts = 0
	all_items_are_coins = true
	for slot in get_children():
		if slot.filled:
			total_sts += slot.get_STS()
			if slot.get_STS() != item_weight:
				all_items_are_coins = false
			
	
	var is_correct: bool = false	
	match logical_operator:
		"==":
			is_correct = total_sts == target_weight
		">=":
			is_correct = total_sts >= target_weight
		"<=":
			is_correct = total_sts <= target_weight
		"<":
			is_correct = total_sts < target_weight
		">":
			is_correct = total_sts > target_weight
		"!=":
			is_correct = total_sts != target_weight
		_:
			label.text = "Invalid Operator"
			print("Invalid logical operator: %s" % logical_operator)
			return
			
	print("Total STS: ", total_sts)
	print("Target Weight: ", target_weight)
	print("Logical Operator: ", logical_operator)
	print("item weight: ", item_weight)
	print("%d %s %d" % [total_sts, logical_operator, target_weight])
			
	if is_correct and all_items_are_coins:
		handle_correct_answer()
	else:
		handle_wrong_answer()
		
	await get_tree().create_timer(0.5).timeout
	is_confirming = false
				
			
func handle_wrong_answer():
	
	label.text = "Incorrect"
	game_manager.decrease_health()
	pause_menu.hide()
	pause_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.text = "Try Again"
	mimic.play("reveal")
	is_ready_to_check = false
		
	if timeline_file:
		Dialogic.start(timeline_file)
		
func handle_correct_answer():
	label.text = "Correct!"
	await get_tree().create_timer(1.5).timeout
	pause_menu.hide()
	button_should_close = true
	mimic.play("opened")
	opened = true
	print("MIMIC OPENEDDDDD")
	
		

	if is_instance_valid(clues):
		clues.show()
		collision_shape_2d.disabled = false
	
	if opened:
		ui.hide()
		label.text = "This is the greed they talk about in the bible..."
		print("Clue is now collectible")
		

	
	emit_signal("correct_answer_handled")
	
	if timeline_file2:
		Dialogic.start(timeline_file2)
	
	
func  _input(event: InputEvent) -> void:
	if event.is_action_pressed("enter"):
		print(event)
		confirm_slots()
	
func is_open() -> bool:
	print("Mimic is open called. State: ", opened)
	return opened
	
func button_should_cloes():
	print("Button should be closed. State: ", button_should_close)
	return button_should_close
