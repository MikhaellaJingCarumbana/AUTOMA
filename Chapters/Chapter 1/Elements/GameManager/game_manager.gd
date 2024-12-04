extends Node

@export var hearts: Array[Node]
@onready var clue_system: Control = $"../UI/Clue_System/CarouselSelection"

var points = 0
var lives = 5
var clues_collected = 0

signal clue_collected(index: int)


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
		

	
	
	
