extends Node

var input_sequence: Array[String] = []
var levers_pulled: Array[Node] = []
@onready var label: Label = $"../Label"
@export var gate_node: NodePath  # Optional: assign a door/gate node here

# Sequences the player must match in order
var correct_sequences: Array = [
	["a", "a", "a"],  # Stage 1
	["b", "a", "b"],  # Stage 2
	["a", "b", "a"]   # Stage 3 (add more as needed)
]

var stage: int = 0

var stage_clues: Array = [
	"The truth must echo thrice.",
	"The lie surrounds the truth.",
	"The first and last must mirror."
]

func _ready():
	update_clue()

func submit_input(symbol: String, lever: Node):
	input_sequence.append(symbol)
	levers_pulled.append(lever)
	
	if input_sequence.size() == 3:
		if input_sequence == correct_sequences[stage]:
			print("Stage %d Solved!" % stage)
			label.text = ""
			stage += 1

			if stage >= correct_sequences.size():
				label.text = "The ancient seals have been broken. The path is revealed."
				if gate_node:
					get_node(gate_node).open_gate()
			else:
				await get_tree().create_timer(2.0).timeout
				update_clue()
			
			reset_puzzle()
		else:
			print("Wrong sequence. Try again.")
			label.text = get_incorrect_message()
			await get_tree().create_timer(1.5).timeout
			update_clue()
			reset_puzzle()

func reset_puzzle():
	for lever in levers_pulled:
		lever.reset_lever()
	input_sequence.clear()
	levers_pulled.clear()

func update_clue():
	if stage < stage_clues.size():
		label.text = stage_clues[stage]
	else:
		label.text = "The final riddle lies ahead..."

# This function will generate a thematic incorrect message
func get_incorrect_message() -> String:
	var messages = [
		"A shudder echoes from the walls... your choice was wrong.",
		"The shadows laugh at your failure, the path remains hidden.",
		"The puzzle mocks you, the gate will not open yet."
	]
	return messages[randi() % messages.size()]
