extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var is_up: bool = false
var player_nearby: bool = false
@export var symbol: String = "a"  # 'a' or 'b'
@onready var puzzle_manager: Node = $"../PuzzleManager"


func _ready() -> void:
	anim.play("Down")  # Start with "Down" animation by default

func _process(_delta: float) -> void:
	# Check for player proximity and interaction
	if player_nearby and Input.is_action_just_pressed("interact"):
		toggle_lever()  # Call toggle function to switch animation and update state

		# Send the input sequence to the puzzle manager each time the lever is interacted with
		puzzle_manager.submit_input(symbol, self)

func toggle_lever():
	# Toggle the lever's state and animation
	if is_up:
		anim.play("Down")
		is_up = false
	else:
		anim.play("Up")
		is_up = true

func _on_body_entered(body: Node2D) -> void:
	# Player has entered the area around the lever
	if body.is_in_group("Player"):
		player_nearby = true

func _on_body_exited(body: Node2D) -> void:
	# Player has exited the area
	if body.is_in_group("Player"):
		player_nearby = false

func reset_lever():
	# Reset the lever to its default "Down" state
	anim.play("Down")
	is_up = false
