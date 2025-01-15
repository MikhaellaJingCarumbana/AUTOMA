extends Node

@export var hearts: Array[Node]
@export var shoot_duration: float = 5.0
@export var cooldown_duration: float = 5.0

@onready var note_system: Control = $"../UI/Note System/CarouselSelection"
@onready var clue_system: Control = $"../UI/Clue_System2/CarouselSelection"
@onready var powerup_choose: Node = $"../UI/Powerup_Choose"
@onready var player: Player = $"../Player"
@onready var pause_menu: ColorRect = $"../UI/Powerup_Choose/PauseMenu"
@onready var player_area: Area2D = $"../Player/Interaction Component/Group"
@onready var hurt_player_effect: CanvasLayer = $"../HurtPlayerEffect"
@onready var anim: AnimatedSprite2D = $"../Player/AnimatedSprite2D"

var can_shoot: bool = true
var shoot_timer: Timer
var cooldown_timer: Timer
var enemy_groups: Dictionary = {}
var group_counter: int = 0

var points = 0
var lives = 5
var magic = 5
var clues_collected = 0
var notes_collected = 0

signal clue_collected(index: int)
signal note_collected(index: int)

var charge_level = 0
var max_charge = 5

var is_powerup_active: bool = false
var powerup_time_left: float = 0.0




func _ready() -> void:
	if powerup_choose:
		powerup_choose.connect("powerup_selected", _apply_powerup)
	
	for i in range(hearts.size()):
		if i < lives:
			hearts[i].show()
		else:
			hearts[i].hide()
	print("HEARTS INITIALIZED. VISIBLE HEARTS: ", magic)
	
	
	shoot_timer = Timer.new()
	shoot_timer.wait_time = shoot_duration
	shoot_timer.timeout.connect(_on_shoot_timeout)
	add_child(shoot_timer)
	
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = cooldown_duration
	cooldown_timer.timeout.connect(_on_cooldown_timeout)
	add_child(cooldown_timer)
	
	can_shoot = true
	print("PLAYER READY TO SHOOT")
	
	
func _on_shoot_timeout():
	can_shoot = false
	print("DEBUG: Shooting duration ended. Entering cooldown phase.")
	cooldown_timer.start()
	decrease_magic()
	
func _on_cooldown_timeout():
	can_shoot = true
	print("DEBUG: Cooldown complete. Player can shoot again.")
	shoot_timer.start()
	increase_magic()
	
func decrease_magic():
	$"../CanvasLayer/Panel2/Label".text = "COOLING DOWN"
			
func increase_magic():
	$"../CanvasLayer/Panel2/Label".text = "SHOOT"
	
	
func _on_powerup_collected() -> void:
	print("DEBUG: Powerup collected!")
	pause_menu.show()

func _process(delta: float) -> void:
	if is_powerup_active:
		powerup_time_left -= delta
		print("DEBUG: GameManager Power-up Time Remaining: %.2f seconds" % powerup_time_left)

		if powerup_time_left <= 0:
			reset_player_powerup()
		else:
			print("DEBUG: Power-up time remaining: %.2f seconds" % powerup_time_left)
			

			

func decrease_health():
	lives -= 1
	hurt_player_effect.show_hurt_effect()
	print(lives)
	for h in 5:
		if (h < lives):
			hearts[h].show()
		else:
			hearts[h].hide()
	if lives <= 0:
		get_node("../UI/DeathScreen").game_over()
		
func increase_health():
	print("CURRENT LIVES BEFORE INCREMENT: ", lives)
	if lives < hearts.size():
		lives += 1
		print("LIVES INCREASED! CURRENT LIVES: ", lives)
		for h in range(hearts.size()):
			if h < lives:
				hearts[h].show()
			else:
				hearts[h].hide()
	else:
		print("MAX HEALTH REACHEDDD!!!!")
				
			
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
		
		if player:
			player.has_infinite_projectiles = false
			print("DEBUG: Player power-up reset to default.")

func _apply_powerup(powerup_type: String) -> void:
	match powerup_type:
		"speed":
			player.speed_boost()
		"jump":
			player.jump_boost()
		_:
			print("DEBUG: Unknown powerup type: %s" % powerup_type)
			
	pause_menu.hide()
	print("DEBUG: UI hidden after selection!")
	
func activate_powerup_menu():
	powerup_choose.show_powerup_menu()
	powerup_choose.connect("powerup_selected", _on_powerup_selected)
	
func _on_powerup_selected(powerup_type: String) -> void:
	powerup_choose.disconnect("powerup_selected", _on_powerup_selected)
	match powerup_type:
		"jump":
			player.boost_jump()
		"speed":
			player.boost_speed()
	print("DEBUG: Power-up applied: %s" % powerup_type)

func _on_star_powerup_collected(powerup_type: String) -> void:
	if powerup_type == "infinite projectiles":
		player.activate_infinite_projectiles()
		print("DEBUG: * Powerup collected! Infinite projectiles enabled.")
		




		

	
