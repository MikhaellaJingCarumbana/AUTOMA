class_name DropHandler
extends Node2D

@onready var droppable_item : PackedScene = preload("res://Chapters/Chapter 1/Sprite/Props animated/items/note.tscn")

var current_note_count : int = 0

func _ready():
	current_note_count = 1
	
func add_note(value : int):
	current_note_count += value
	
