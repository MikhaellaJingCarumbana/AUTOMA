extends CharacterBody2D

class_name Player

var SPEED = 200.0
var original_speed = SPEED
var speed_boost_active = false
var JUMP_VELOCITY = -560.0
@onready var sprite_2d = $AnimatedSprite2D
@onready var all_interactions = []
@onready var InteractLabel = $"Interaction Component/InteractionArea/InteractLabel"
@onready var game_manager = %GameManager
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_facing_left = false  # Tracks the direction the character is facing
var movable = true
var is_dead = false
var has_charge_powerip = false
var jump_boost_timer: Timer
var powerup_duration: float = 10.0

var jump_count = 0
var max_jumps = 4
var has_infinite_projectiles: bool = false

@export var projectile_scene: PackedScene
@export var shoot_cooldown: float = 0.0
var is_infinite_projectiles_active = false
var projectile_timer: Timer

var shoot_timer = 0.0
var prev_projectile_powerup_state: bool = false

var is_grouping_enabled: bool = false

@onready var group: Area2D = $Group
@export var grouping_range: float = 200.0
@export var max_group_size: int = 3
var grouped_enemies: Array = []



func _ready():
	NavigationManager.on_triggr_player_spawn.connect(_on_spawn)
	update_interactions()
	Global.playerBody = self
	jump_boost_timer = Timer.new()
	jump_boost_timer.one_shot = true
	add_child(jump_boost_timer)
	jump_boost_timer.timeout.connect(_reset_speed_boost)
	jump_boost_timer.timeout.connect(_reset_jump_boost)
	
	projectile_timer = Timer.new()
	projectile_timer.one_shot = true
	add_child(projectile_timer)
	projectile_timer.timeout.connect(deactivate_projectile_powerup)
		

func _process(delta):
	if shoot_timer > 0:
		shoot_timer -= delta
		
	if Input.is_action_just_pressed("shoot") and is_infinite_projectiles_active:
		shoot_projectile()
		shoot_timer = shoot_cooldown
	elif Input.is_action_just_pressed("shoot"):
		print("Can't shoot! No powerup projectile")
		
	if is_infinite_projectiles_active != prev_projectile_powerup_state:
		if is_infinite_projectiles_active:
			print("Infinite projectiles active. Timer countdown: %.2f seconds" % projectile_timer.get_time_left())
		else:
			print("No Active powerup")
		prev_projectile_powerup_state = is_infinite_projectiles_active

func jump():
	if jump_count < max_jumps:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		print("Jump count: %d" % jump_count)
	
	
func _input(event):
	if event.is_action_pressed("shoot") and is_infinite_projectiles_active:
		shoot_projectile()
		
	if event.is_action_pressed("group_attack") and grouped_enemies:
		deal_group_damage(80)
		
func jump_slide(x):
	velocity.y = JUMP_VELOCITY
	velocity.x = x
	
func boost_jump():
	if not has_charge_powerip:
		has_charge_powerip = true
		JUMP_VELOCITY -= 200
		print("DEBUG: Jump boost activated!")
		jump_boost_timer.start(powerup_duration)
		
func _reset_jump_boost():
	has_charge_powerip = false
	JUMP_VELOCITY += 200
	print("DEBUG: Jump boost reset.")
	
func boost_speed():
	if not speed_boost_active:
		speed_boost_active = true
		SPEED += 100
		print("DEBUG: Speed boost activated!")
		jump_boost_timer.start(powerup_duration)
		
func shoot_projectile() -> void:
	
	if projectile_scene:
		var projectile = projectile_scene.instantiate()
		get_parent().add_child(projectile)
		projectile.position = global_position + Vector2(-20 if is_facing_left else 20,0)
		var direction = Vector2.LEFT if is_facing_left else Vector2.RIGHT
		projectile.initialize(direction)
		print("DEBUG: Projectile shot!")
	
	if is_infinite_projectiles_active:
		print("Projectile shot with powerup!")
	else:
		print("Projectile shot without powerup")
		
func _on_spawn(position: Vector2, direction: String):
	global_position = position
	sprite_2d.play("Run")
	sprite_2d.stop()

func _physics_process(delta):
	if is_dead:
		return
	# Update animation based on velocity
	if velocity.x > 1 or velocity.x < -1:
		sprite_2d.play("Run")
		is_facing_left = velocity.x < 0  # Update facing direction
	elif not is_on_floor():
		sprite_2d.play("Jump")
	else:
		sprite_2d.play("Idle")

	# Flip the sprite based on the last known direction
	sprite_2d.flip_h = is_facing_left
	

	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			jump()

	# Get the input direction and handle movement/deceleration
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 12)

	move_and_slide()

	# Handle interactions
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
	
	if game_manager.lives == 0 and not is_dead:
		play_death_animation()
		
	#reset jump count when on the floor
	if is_on_floor():
		jump_count = 0
		
		
func _on_powerup_timeout():
	deactivate_projectile_powerup()
	print("DEBUG: * Powerup expired! Infinite projectiles disabled.")
	
func _can_shoot_normal():
	return
	
func play_death_animation():
	is_dead = true
	sprite_2d.play("Death")
		

func _on_interaction_area_area_entered(area):
	all_interactions.insert(0, area)
	update_interactions()
	print("Entered interaction area")

func _on_interaction_area_area_exited(area):
	all_interactions.erase(area)
	update_interactions()
	print("Exited interaction area")

func update_interactions():
	if all_interactions:
		InteractLabel.text = all_interactions[0].interact_label
	else:
		InteractLabel.text = " "

func execute_interaction():
	if all_interactions:
		var current_interaction = all_interactions[0]
		match current_interaction.interact_type:
			"print_text":
				print(current_interaction.interact_value)
			"open_dialogic_timeline":
				open_dialogic_timeline(current_interaction.timeline_name)
			"open_chest":
				current_interaction.get_parent().open_chest()
			"open_door_code":
				current_interaction.interact()
		print("Executing interaction: %s" % current_interaction.interact_type)
			

func open_dialogic_timeline(timeline_name):
	print("Starting Dialogic timeline: %s" % timeline_name)
	Dialogic.start(timeline_name)
	
func jump_boost():
	if not has_charge_powerip:
		boost_jump()

func speed_boost():
	if not has_charge_powerip:
		boost_speed()
		

func _reset_speed_boost():
	speed_boost_active = false
	SPEED = original_speed
	print("DEBUG: Speed boost reset.")
		
		
func _reset_powerup():
	has_charge_powerip = false
	max_jumps = 1
	JUMP_VELOCITY = -560.0
	print("DEBUG: Powerup expired. Jump reset.")

func start_timer():
	projectile_timer.wait_time = powerup_duration
	projectile_timer.start()
	
func get_timer_time_left() -> float:
	return projectile_timer.get_time_left()
	

	
func activate_projectile_powerup_powerup() -> void:
	if not is_infinite_projectiles_active:
		is_infinite_projectiles_active = true
		projectile_timer.start(powerup_duration)
		print("DEBUG: Infinite projectiles activated for %.2f seconds" % powerup_duration)
		
func deactivate_projectile_powerup() -> void:
	is_infinite_projectiles_active = false
	print("DEBUG: Infinite projectiles deactivated.")


func _on_star_powerup_collected(player: Node2D):
	print("Powerup collected signal received")
	is_infinite_projectiles_active = true
	projectile_timer.start(powerup_duration)
	
	
func attack_enemy(enemy: SkullEnemy, damage: int):
	if game_manager.has_method("enemy_groups") and game_manager.enemy_groups.has("Skull"):
		for grouped_enemy in game_manager.enemy_groups["Skull"]:
			if grouped_enemy and not grouped_enemy.dead:
				grouped_enemy.take_damage(damage)
				
	else:
		enemy.take_damage(damage)

func activate_grouping_powerup():
	var nearby_enemies = []
	for enemy_type in game_manager.enemy_groups.keys():
		for enemy in game_manager.enemy_groups[enemy_type]:
			if position.distance_to(enemy.position) <= grouping_range and not enemy.grouped:
				nearby_enemies.append(enemy)
				
	nearby_enemies.sort_custom(_compare_distance)
	
	var grouped_count = min(nearby_enemies.size(), 3)
	
	for i in range(grouped_count):
		var enemy = nearby_enemies[i]
		enemy.grouped = true
		if game_manager.has_method("add_enemy_to_group"):
			game_manager.add_enemy_to_group(enemy.enemy_type, enemy)
	print("DEBUG: Grouping powerup activated.")
	
func _compare_distance(a, b):
	var dist_a = position.distance_to(a.position)
	var dist_b = position.distance_to(b.position)
	return dist_a < dist_b


func _on_group_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemies"):
		if area not in grouped_enemies:
			grouped_enemies.append(area)
			_apply_visual_change(area)
			print("ENEMY HAS ENTERED RANGE. CURRENT GROUPED ENEMIES: %d" % grouped_enemies.size())
			
		if is_grouping_enabled:
			attempt_group_formation()
			
func _on_group_area_exited(area: Area2D) -> void:
	if area in grouped_enemies:
		grouped_enemies.erase(area)
		print("ENEMY EXITED RANGE. REMAINING GROUPED ENEMIES: %d" %grouped_enemies.size())
		
func attempt_group_formation() -> void:
	if grouped_enemies.size() >= max_group_size:
		var group_candidates = grouped_enemies.slice(0, max_group_size)
		game_manager.add_enemy_to_group("default", group_candidates)
		grouped_enemies = grouped_enemies.slice(max_group_size)
		print("NEW GROUPED FORMED WITH %d enemies. REMAINING UNGROUPED: %d" % [max_group_size, grouped_enemies.size()])
func _apply_visual_change(enemy: Node):
	if enemy.has_node("AnimatedSprite2D"):
		var sprite = enemy.get_node("AnimatedSprite2D")
		sprite.modulate = Color(1, 0.5, 0.5)
		
func _remove_visual_change(enemy: Node):
	if enemy.has_node("AnimatedSprite2D"):
		var sprite = enemy.get_node("AnimatedSprite2D")
		sprite.modulate = Color(1, 1, 1)
		
func deal_group_damage(damage: int):
	if not is_grouping_enabled:
		print("ERROR: Grouping is not enabled.")
		return
		
	for enemy in grouped_enemies:
		if enemy and not enemy.dead:
			enemy.apply_damage(damage)
			print("DEBUG: Dealt %d damage to %s" % [damage, enemy.name])
			
	grouped_enemies.clear()
	is_grouping_enabled = false
	print("DEBUG: Group attack completed. Grouping disabled.")
	
func reset_grouping():
	is_grouping_enabled =false
	grouped_enemies.clear()
	print("DEBUG: Grouping reset.")
