extends Node

@export var hearts: Array[Node]
@onready var note_system: Control = $"../UI/Note System/CarouselSelection"
@onready var clue_system: Control = $"../UI/Clue_System/CarouselSelection"
@onready var hurt_player_effect: CanvasLayer = $"../HurtPlayerEffect"
@onready var anim: AnimatedSprite2D = $"../Player/AnimatedSprite2D"
@onready var player: Player = $"../Player"




var points = 0
var lives = 5
var clues_collected = 0
var notes_collected = 0

signal clue_collected(index: int)
signal note_collected(index: int)


func decrease_health():
	lives -= 1
	hurt_player_effect.show_hurt_effect()
	player.hurt()
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


	
	
	
