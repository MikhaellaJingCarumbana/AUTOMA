extends Control

var tween_hover: Tween

var displacement: float = 0.0 
var oscillator_velocity: float = 0.0

var tween_rot: Tween
var tween_destroy: Tween
var tween_handle: Tween

var last_mouse_pos: Vector2
var mouse_velocity: Vector2
var following_mouse: bool = false
var last_pos: Vector2
var velocity: Vector2
@export var hover_scale: Vector2 = Vector2(1.2, 1.2)  # How much the button scales on hover
@export var hover_duration: float = 0.5  # Duration of the hover effect
@onready var audio: AudioStreamPlayer2D = $Audio

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween_hover = create_tween()
	

func _on_button_pressed() -> void:
	pass

func _on_button_mouse_entered() -> void:
	audio.play()
	$CanvasLayer/Button/Card_back/AnimationPlayer.play("Card_flip")
	print("Mouse_Entered")
	
func _on_button_mouse_exited() -> void:
	audio.play()
	$CanvasLayer/Button/Card_back/AnimationPlayer.play("Card_flip_2")
	print("Mouse exited")
