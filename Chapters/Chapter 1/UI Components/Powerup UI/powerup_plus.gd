extends Node

signal powerup_selected(powerup_type)
@onready var pause_menu: ColorRect = $PauseMenu
@onready var jump_button: Button = $PauseMenu/HBoxContainer/JumpButton
@onready var speed_button: Button = $PauseMenu/HBoxContainer/SpeedButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.hide()

func show_powerup_menu():
	pause_menu.show()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_jump_button_pressed() -> void:
	pause_menu.hide()
	emit_signal("powerup_selected", "jump")
	print("DEBUG: Jump power-up selected.")

func _on_speed_button_pressed() -> void:
	pause_menu.hide()
	emit_signal("powerup_selected", "speed")
	print("DEBUG: Speed power-up selected.")
