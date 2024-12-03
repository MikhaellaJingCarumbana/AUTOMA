extends Node

@export var hearts : Array[Node]

var points = 0
var lives = 5

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
	
		
func clues_collected(clue_index: int):
	emit_signal("clue_collected", clue_index)
	
	
