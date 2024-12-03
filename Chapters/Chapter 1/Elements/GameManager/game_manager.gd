extends Node

@export var hearts : Array[Node]

var points = 0
var lives = 5

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
	
		
func add_point():
	points += 1
	print(points)
	
func clue_collected(clue_id: String) -> void:
	print("Clue collected: " + clue_id)
	
	
	match clue_id:
		"clue_1":
			collected1()
		"clue_2":
			collected2()
		_:
			print("No Specific action for this clue")

func collected1() -> void:
	print("Collected clue 1: Trigger specific event!")

func collected2() -> void:
	print("Collected clue 2: Trigger another specific event!")
