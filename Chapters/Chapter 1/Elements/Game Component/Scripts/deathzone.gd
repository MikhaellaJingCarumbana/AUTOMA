extends Area2D

var checkpoint_manager
var player
var game_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	checkpoint_manager = get_parent().get_node("CheckpointManager")
	player = get_parent().get_node("Player")
	game_manager = get_parent().get_node("GameManager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("Player"):
		killPlayer()

func killPlayer():
	game_manager.decrease_health()
	player.position = checkpoint_manager.last_location
