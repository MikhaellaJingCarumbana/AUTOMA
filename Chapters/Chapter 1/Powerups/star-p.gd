extends Area2D

@export var powerup_type: String = ""
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
	print("DEBUG: Body entered powerup area:", body.name)
	if visible and body.is_in_group("Player"):
		print("DEBUG: Power-up collected by player.")
		apply_powerup_effect(body)
		game_manager.emit_signal("powerup_collected", powerup_type)
		queue_free()
	elif not visible:
		print("DEBUG: Note is not visible; cannot be collected.")
		
		
func apply_powerup(player: Node2D) -> void:
	
	if not is_powerup_active:
		is_powerup_active = true
		
func _on_powerup_timer_timeout() -> void:
	var player = get_tree().get_current_scene().get_node("Player")
	if player and player.has_infinite_projectiles:
		player.has_infinite_projectiles = false
		print("DEBUG: Infinite projectiles effect expired.")

func apply_powerup_effect(player: Node2D):
	if not player.has_infinite_projectiles:
		player.has_infinite_projectiles = true
		print("DEBUG: Infinite projectiles activated.")
		powerup_timer.start(powerup_duration)
		
