extends Area2D

@export var powerup_duration: float = 3.0 
@export var float_amplitude: float = 5.0
@export var float_speed: float = 4.0
@export var jump_boost: int = -200


@onready var powerup_timer: Timer = $PowerupTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var parent_enemy: NodePath
@onready var enemy: SkullEnemy = get_node_or_null(parent_enemy)

@onready var game_manager: Node = get_parent().get_parent().get_node("GameManager")

var base_y_position: float = 0.0
var time_elapsed: float = 0.0
var is_floating: bool = false
var is_powerup_active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	set_visibility_layer_bit(0, true)
	set_collision_mask_value(0, true)
	print("DEBUG: Note initialized as invisible and non-collidable.")
	
	base_y_position = position.y 

	if enemy:
		print("DEBUG: Bound to parent_enemy: ", enemy.name)
		enemy.connect("tree_exiting", _on_enemy_freed)
	else:
		print("ERROR: parent_enemy is not set or invalid.")
		
	#start the timer for demonstration
	powerup_timer.stop()

func _on_powerup_collected():
	if not is_powerup_active:
		apply_powerup_effect()
		powerup_timer.wait_time = 10.0
		powerup_timer.start()
		is_powerup_active = true
		print("DEBUG: Power-up collected! Timer started for %.2f seconds." % powerup_timer.wait_time)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_floating:
		time_elapsed += delta
		position.y = base_y_position + sin(time_elapsed * float_speed) * float_amplitude
	elif enemy and enemy.dead:
		make_visible_at_enemy_position()
	
	if is_powerup_active:
		print("DEBUG: Timer running. Time left: %.2f seconds" % powerup_timer.get_time_left())
		
		
func make_visible_at_enemy_position() -> void:
	print("DEBUG: Making note visible at enemy position.")
	global_position = enemy.global_position  # Capture the enemy's position
	visible = true
	set_collision_layer_value(0, true)
	set_collision_mask_value(0, true)
	animated_sprite_2d.play("default")
	base_y_position = position.y
	is_floating = true
	print("DEBUG: Note made visible at position: ", global_position)


func _on_enemy_freed() -> void:
	print("DEBUG: Enemy has been freed: ", enemy.name)
	if enemy:
		make_visible_at_enemy_position()
		enemy = null
	else:
		print("ERROR: Enemy reference lost before being freed")
	
func _on_body_entered(body: Node2D) -> void:
	print("DEBUG: Body entered Note area:", body.name)
	if visible and body.is_in_group("Player"):
		print("DEBUG: Player collected the + powerup!")
		apply_powerup(body)
		queue_free()
	elif not visible:
		print("DEBUG: Note is not visible; cannot be collected.")
		
	if body.is_in_group("Player") and not is_powerup_active:
		apply_powerup(body)
		queue_free()
		
func apply_powerup(player: Node2D) -> void:
	
	if player is Player:
		player.has_charge_powerip = true
		player.JUMP_VELOCITY = -760.0
	
		if game_manager:
			game_manager.activate_player_powerup(5.0)
		else:
			print("ERROR: GameManager not found!")
		
		queue_free()
		
func _on_powerup_timer_timeout() -> void:
	if is_powerup_active:
		var player = get_tree().get_current_scene().get_node("Player")
		if player:
			player.has_charge_powerip = false
			player.JUMP_VELOCITY = -560.0
			
		is_powerup_active = false
		print("DEBUG: Power-up expired. Player reset to default settings.")
func apply_powerup_effect():
	print("DEBUG: Power-up effect applied")
	
func reset_to_default():
	if is_powerup_active:
		is_powerup_active = false
		powerup_timer.stop()
		var player = get_tree().get_current_scene().get_node("Player")
		if player:
			player.has_charge_powerip = false
			player.JUMP_VELOCITY = -560.0
		print("DEBUG: Powerup expired. Player reset to default settings.")
