extends Area2D

@export var checkpoint_manager: Node
var player
@onready var game_manager: Node = %GameManager

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if game_manager:
			game_manager.decrease_health()
			killPlayer()

func killPlayer():
	player.position = checkpoint_manager.last_location
	
