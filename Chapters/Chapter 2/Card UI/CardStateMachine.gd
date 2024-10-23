class_name CardStateMachine
extends Node

@export var initial_phase: CardState

var current_phase: CardState
var phases:= {}

func init(card: CardUI) -> void:
	for child in get_children():
		if child is CardState:
			phases[child.phase] = child
			child.transition_requested.connect(_on_transition_requested)
			child.card_ui = card
	
	if initial_phase:
		initial_phase.enter()
		current_phase = initial_phase

func on_input(event: InputEvent) -> void:
	if current_phase:
		current_phase.on_input(event)

func on_gui_input(event: InputEvent) -> void:
	if current_phase:
		current_phase.on_gui_input(event)

func on_mouse_entered() -> void:
	if current_phase:
		current_phase.on_mouse_entered()

func on_mouse_exited() -> void:
	if current_phase:
		current_phase.on_mouse_exited()

func _on_transition_requested(from: CardState, to: CardState.Phase) -> void:
	if from != current_phase:
		return
	
	var new_phase: CardState = phases[to]
	if not new_phase:
		return
	
	if current_phase:
		current_phase.exit()
	
	new_phase.enter()
	current_phase = new_phase
