extends Node2D
class_name State

@onready var debug = owner.find_child("debug")
@onready var player = owner.get_parent().find_child("Player")
@onready var animation_player = $"../../AnimatedSprite2D"
@onready var health: AnimationPlayer = $"../../AnimationPlayer"
@onready var ui: CanvasLayer = $"../../UI"

var can_transition: bool = true

func _ready():
	set_physics_process(false)

func enter():
	set_physics_process(true)
	
func exit():
	set_physics_process(false)
	
func transition():
	pass

func _physics_process(delta: float) -> void:
	transition()
	debug.text = name
