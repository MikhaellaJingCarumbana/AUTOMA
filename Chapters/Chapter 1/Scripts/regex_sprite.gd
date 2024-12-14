extends CharacterBody2D

class_name Player

const SPEED = 200.0
const JUMP_VELOCITY = -560.0
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

func jump():
	velocity.y = JUMP_VELOCITY
	
func jump_slide(x):
	velocity.y = JUMP_VELOCITY
	velocity.x = x
	
func _ready():
	NavigationManager.on_triggr_player_spawn.connect(_on_spawn)
	update_interactions()
	Global.playerBody = self
		
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
		if has_charge_powerip:
			charge_jump()
		else: 
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
	
func charge_jump():
	if has_charge_powerip:
		game_manager.increase_charge()
		velocity.y = JUMP_VELOCITY - (game_manager.charge_level * 50)
		print("Charge jumo with charge level:", game_manager.charge_level)
	else:
		jump()
