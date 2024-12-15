extends Node

@export var hearts: Array[Node]
@onready var note_system: Control = $"../UI/Note System/CarouselSelection"
@onready var clue_system: Control = $"../UI/Clue_System2/CarouselSelection"
@onready var powerup_choose: ColorRect = $"../UI/Powerup_Choose/PauseMenu"
@onready var player: Player = $"../Player"



var points = 0
var lives = 5
var clues_collected = 0
var notes_collected = 0

signal clue_collected(index: int)
signal note_collected(index: int)

var charge_level = 0
var max_charge = 5

var is_powerup_active: bool = false
var powerup_time_left: float = 0.0


func _ready() -> void:
	powerup_choose.connect("powerup_selected", _apply_powerup)
	
func _on_powerup_collected() -> void:
	print("DEBUG: Powerup collected!")
	powerup_choose.show()

func _process(delta: float) -> void:
	if is_powerup_active:
		powerup_time_left -= delta
		if powerup_time_left <= 0:
			reset_player_powerup()
		else:
			print("DEBUG: Power-up time remaining: %.2f seconds" % powerup_time_left)
			


func decrease_health():
	lives -= 1
	print(lives)
	for h in 5:
		if (h < lives):
			hearts[h].show()
		else:
			hearts[h].hide()
	if (lives == 0):
		get_node("../UI/DeathScreen").game_over()
	
		
func add_clue():
	clues_collected += 1
	if clue_system:
		print("Clue collected!")
		clue_system.call("show_clue", clues_collected)
	else:
		print("Error: clue_system is not assigned!")
		
func add_note():
	notes_collected += 1
	if note_system:
		print("Note collected!")
		note_system.call("show_note", notes_collected)
	else:
		print("Error: clue_system is not assigned!")
		
func activate_player_powerup(duration: float) -> void:
	is_powerup_active = true
	powerup_time_left = duration
	print("DEBUG: Power-up activated! Duration: %.2f seconds" % duration)
		
func reset_player_powerup():
	if is_powerup_active:
		is_powerup_active = false
		powerup_time_left = 0.0
		print("DEBUG: Power-up expired. Resetting player to default settings.")
		
		var player = get_tree().get_current_scene().get_node("Player")
		if player:
			player.has_charge_powerip = false
			player.JUMP_VELOCITY = -560.0
			print("DEBUG: Player power-up reset complete.")

func _apply_powerup(powerup_type: String) -> void:
	match powerup_type:
		"speed":
			player.speed_boost()
		"jump":
			player.jump_boost()
		_:
			print("DEBUG: Unknown powerup type: %s" % powerup_type)
			
	powerup_choose.hide()
	print("DEBUG: UI hidden after selection!")

	
