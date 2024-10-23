class_name CardState
extends Node

enum Phase {BASE, CLICKED, DRAGGING, RELEASED, PLAYING}

signal transition_requested(from: CardState, to: Phase)

@export var phase: Phase

var card_ui: CardUI

func enter() -> void:
	pass

func exit() -> void:
	pass

func on_input(_event: InputEvent) -> void:
	pass

func on_gui_input(_event: InputEvent) -> void:
	pass

func on_mouse_entered() -> void:
	pass

func on_mouse_exited() -> void:
	pass
