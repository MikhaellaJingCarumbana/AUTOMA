extends CharacterBody2D

class_name Player

# Define states for the Finite State Machine
enum PlayerState { IDLE, RUNNING, JUMPING }
var state = PlayerState.IDLE

const SPEED = 200.0
const JUMP_VELOCITY = -560.0
@onready var sprite_2d = $AnimatedSprite2D
@onready var all_interactions = []
@onready var InteractLabel = $"Interaction Component/InteractionArea/InteractLabel"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_facing_left = false  # Tracks the direction the character is facing
var movable = true

# Player movement functions
func jump():
	velocity.y = JUMP_VELOCITY
	state = PlayerState.JUMPING
	
func jump_slide(x):
	velocity.y = JUMP_VELOCITY
	velocity.x = x
	state = PlayerState.JUMPING
	
func _ready():
	NavigationManager.on_triggr_player_spawn.connect(_on_spawn)
	update_interactions()
	Global.playerBody = self
		
func _on_spawn(position: Vector2, direction: String):
	global_position = position
	sprite_2d.play("Run")
	sprite_2d.stop()

# Main FSM logic
func _physics_process(delta):
	match state:
		PlayerState.IDLE:
			if Input.get_axis("ui_left", "ui_right") != 0:
				state = PlayerState.RUNNING
			elif Input.is_action_just_pressed("ui_accept") and is_on_floor():
				jump()
		PlayerState.RUNNING:
			if Input.get_axis("ui_left", "ui_right") == 0:
				state = PlayerState.IDLE
			elif Input.is_action_just_pressed("ui_accept") and is_on_floor():
				jump()
			else:
				move()
		PlayerState.JUMPING:
			if is_on_floor():
				state = PlayerState.IDLE
	
	apply_gravity(delta)
	update_animation()

func move():
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED
	is_facing_left = velocity.x < 0
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

# Update animation based on FSM state
func update_animation():
	match state:
		PlayerState.IDLE:
			sprite_2d.play("Idle")
		PlayerState.RUNNING:
			sprite_2d.play("Run")
			sprite_2d.flip_h = is_facing_left
		PlayerState.JUMPING:
			sprite_2d.play("Jump")

# Handle interactions (unchanged)
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
		print("Executing interaction: %s" % current_interaction.interact_type)

func open_dialogic_timeline(timeline_name):
	print("Starting Dialogic timeline: %s" % timeline_name)
	Dialogic.start(timeline_name)
