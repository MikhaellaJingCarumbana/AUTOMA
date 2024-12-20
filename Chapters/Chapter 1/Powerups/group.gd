extends Area2D

@export var powerup_type: String = ""
@export var powerup_duration: float = 3.0 
@export var float_amplitude: float = 5.0
@export var float_speed: float = 4.0
@export var jump_boost: int = -200
@export var max_group_size: int = 3


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var parent_enemy: NodePath
@onready var enemy: SkullEnemy = get_node_or_null(parent_enemy)

@onready var game_manager: Node = get_parent().get_parent().get_node("GameManager")

var base_y_position: float = 0.0
var time_elapsed: float = 0.0
var is_floating: bool = false
var is_powerup_active: bool = false

signal powerup_collected(player: Node2D)

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
		
	var powerup_timer = Timer.new()
	powerup_timer.name = "PowerupTimer"
	powerup_timer.one_shot = true
	powerup_timer.wait_time = powerup_duration
	add_child(powerup_timer)
	powerup_timer.connect("timeout", _on_powerup_timer_timeout)
	#start the timer for demonstration
	
func activate_powerup():
	if not is_powerup_active:
		is_powerup_active = true
		print("Power-up activated!")
		
		enable_group_powerup_effects()
		
		var timer = $PowerupTimer
		if timer:
			timer.start()
		else:
			print("ERROR: PowerupTimer not found!")
			
func disable_powerup():
	if is_powerup_active:
		is_powerup_active = false
		print("Power-up deactivated!")
		
		disable_group_powerup_effects()

func _on_powerup_timer_timeout():
	disable_powerup()
	
func enable_group_powerup_effects():
	print("Enabling group power-up effects...")
	
	
	

func apply_grouping_logic():
	var grouped_enemies = []
	var player = get_tree().get_current_scene().get_node("Player")
	if not player:
		return
		
	var player_position = player.global_position
	for enemy_type in game_manager.enemy_groups:
		if enemy and not enemy.dead:
			var distance = player_position.distance_to(enemy.global_position)
			if distance < 200 and not enemy.append(enemy):
				enemy.grouped = true
				print("DEBUG: Added enemy to group:", enemy.name)
				
				if grouped_enemies.size() >= max_group_size:
					break
					
	if grouped_enemies.size() > 1:
		for enemy in grouped_enemies:
			enemy.group_id = game_manager.get_new_group_id()
			print("DEBUG: Enemy grouped with ID:", enemy.group_id)
	else:
		print("DEBUG: Not enough enemies nearby to form a group.")
				
func disable_group_powerup_effects():
	pass
	
	var groups = game_manager.enemy_groups
	for enemy_type in groups:
		for enemy in groups[enemy_type]:
			if enemy and not enemy.dead:
				enemy.revert_state()

func _on_powerup_collected(body: Node2D):
	if body is Player:
		emit_signal("powerup_collected")
		queue_free()
		print("DEBUG: Grouping enabled after power-up collection.")
		
func _process(delta: float) -> void:
	if is_floating:
		time_elapsed += delta
		position.y = base_y_position + sin(time_elapsed * float_speed) * float_amplitude
	elif enemy and enemy.dead:
		make_visible_at_enemy_position()
	
	if is_powerup_active:
		var player = get_tree().get_current_scene().get_node("Player")
		if player and player.has_method("get_timer_time_left"):
			var time_left = player.get_timer_time_left()
			if time_left > 0:
				print("DEBUG: Timer running. Time left: %.2f seconds" % time_left)
			
		
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
			is_powerup_active = true
			emit_signal("powerup_collected", body)
			queue_free()
			print("DEBUG: Powerup projectile collected!")
	elif not visible:
		print("DEBUG: Powerup is not visible; cannot be collected.")
		

func apply_powerup_effect(player: Node2D):
	var grouped_enemies = []
	var player_position = player.global_position
	var groups = game_manager.enemy_groups
	for enemy_type in game_manager.enemy_groups:
		for enemy in game_manager.enemy_groups[enemy_type]:
			if enemy and not enemy.dead:
				var distance = player_position.distance_to(enemy.global_position)
				if distance < 200 and not enemy.grouped:
					grouped_enemies.append(enemy)
					enemy.grouped = true
					print("DEBUG: Added enemy to group:", enemy.name)
					
					if grouped_enemies.size() >= max_group_size:
						break
	
	if grouped_enemies.size() > 1:
		for enemy in grouped_enemies:
			enemy.group_id = game_manager.get_new_group_id()
			print("DEBUG: Enemy grouped with ID:", enemy.group_id)
	else:
		print("DEBUG: Not enough enemies nearby to form a group.")
		
func _on_area_entered(area):
	if area.name == "Player":
		area.activate_grouping_powerup()
		queue_free()

func collect_group_powerup():
	if not is_powerup_active:
		is_powerup_active = true
		print("Group powerup collected!")
		enable_group_powerup_effects()
		
		var timer = $PowerupTimer
		if timer:
			timer.start()
		else:
			print("Group Timer not found")
