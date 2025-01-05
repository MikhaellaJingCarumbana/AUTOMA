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

@export var sfx_jump: AudioStream
@export var sfx_footsteps: AudioStream
@onready var sfx_player: AudioStreamPlayer2D = %sfx_player
@export var powerup: AudioStream
@export var powerdown: AudioStream

var footsteps_fram: Array = [2, 4, 6, 8]
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var fire: AnimatedSprite2D = $Fire
@onready var fire_light: PointLight2D = $Fire_light
@onready var white_light: PointLight2D = $white_light
@onready var white: AnimatedSprite2D = $white

@export var shoot: AudioStream
@onready var chest_puzzle: Node = $"../UI/Chest Puzzle/PauseMenu"


func _ready():
	add_to_group("Player")
	fire.play("default")
	fire.visible = false
	fire_light.visible = false
	
	white.play("white")
	white.visible = false
	white_light.visible = false
	
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
	

		
func is_player() -> bool:
	return true
	
func _process(delta):
	if shoot_timer > 0:
		shoot_timer -= delta
		
	if Input.is_action_just_pressed("shoot") and is_infinite_projectiles_active:
		shoot_projectile()
		load_sfx(shoot)
		sfx_player.play()
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
		velocity.y = JUMP_VELOCITY
	
	
func _input(event):
	if event.is_action_pressed("shoot") and is_infinite_projectiles_active:
		shoot_projectile()
	
func jump_slide(x):
	velocity.y = JUMP_VELOCITY
	velocity.x = x
	
func boost_jump():
	if not has_charge_powerip:
		white.visible = true
		white_light.visible = true
		has_charge_powerip = true
		JUMP_VELOCITY -= 200
		print("DEBUG: Jump boost activated!")
		jump_boost_timer.start(powerup_duration)
		
func _reset_jump_boost():
	white.visible = false
	white_light.visible = false
	has_charge_powerip = false
	JUMP_VELOCITY = -560.0
	print("DEBUG: Jump boost reset.")
	
func boost_speed():
	if not speed_boost_active:
		white.visible = true
		white_light.visible = true
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
	

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			jump()
			load_sfx(sfx_jump)
			sfx_player.play()

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
	
func hurt():
	sprite_2d.play("Hurt")
		

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
		print("Processing interaction: %s" % current_interaction.interact_type)
		match current_interaction.interact_type:
			"print_text":
				print(current_interaction.interact_value)
			"open_dialogic_timeline":
				open_dialogic_timeline(current_interaction.timeline_name)
			"open_chest":
				current_interaction.get_parent().open_chest()
				print("interacting with the chest, Player script")
			"open_door_code":
				current_interaction.interact()
				print("interacting with the door code, Plyer script")
			"open_chest_riddle":
				current_interaction.interact_mimic()
				print("Interacting with the chest riddle, player script")
			"open_chest_riddle2":
				current_interaction.interact_mimic2()
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
	white.visible = false
	white_light.visible = false
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
	load_sfx(powerdown)
	sfx_player.play()
	is_infinite_projectiles_active = false
	fire.visible = false
	fire_light.visible = false
	print("DEBUG: Infinite projectiles deactivated.")


func _on_star_powerup_collected(player: Node2D):
	print("Powerup collected signal received")
	load_sfx(powerup)
	sfx_player.play()
	fire.visible = true
	fire_light.visible = true
	is_infinite_projectiles_active = true
	projectile_timer.start(powerup_duration)
	
	
func _compare_distance(a, b):
	var dist_a = position.distance_to(a.position)
	var dist_b = position.distance_to(b.position)
	return dist_a < dist_b

func load_sfx(sfx_to_load):
	if %sfx_player.stream != sfx_to_load:
		%sfx_player.stop()
		%sfx_player.stream = sfx_to_load


func _on_animated_sprite_2d_frame_changed() -> void:
	if sprite.animation == "Idle": return
	if sprite.animation == "Jump": return
	load_sfx(sfx_footsteps)
	if sprite.frame in footsteps_fram: sfx_player.play()
