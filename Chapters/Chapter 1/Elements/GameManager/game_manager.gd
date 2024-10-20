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
		get_tree().reload_current_scene()
		
func add_point():
	points += 1
	print(points)
	
	
