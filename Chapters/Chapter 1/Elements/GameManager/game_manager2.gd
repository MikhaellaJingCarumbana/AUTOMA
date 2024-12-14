extends Node

@export var hearts: Array[Node]
@onready var note_system: Control = $"../UI/Note System/CarouselSelection"
@onready var clue_system: Control = $"../UI/Clue_System2/CarouselSelection"


var points = 0
var lives = 5
var clues_collected = 0
var notes_collected = 0

signal clue_collected(index: int)
signal note_collected(index: int)

var charge_level = 0
var max_charge = 5




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
		
func increase_charge():
	if charge_level < max_charge:
		charge_level += 1
		print("Charge increased to: ", charge_level)
	else:
		print("Charge is at maximum!")

#func start_powerup_timer(player: Player):
	#var powerup_timer = Timer.new()
	#add_child(powerup_timer)
	#powerup_timer.one_shot = true
	#powerup_timer.wait_time = 10.0
	#powerup_timer.connect("timeout", _reset_powerup)
	#powerup_timer.start()
	
	
	
