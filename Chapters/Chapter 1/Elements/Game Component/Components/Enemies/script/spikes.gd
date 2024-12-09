extends Area2D

var checkpoint_manager
var player
var game_manager

var player_inside: bool = false
var health_decrease_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	checkpoint_manager = get_parent().get_node("CheckpointManager")
	player = get_parent().get_node("Player")
	game_manager = get_parent().get_node("%GameManager")
	
	health_decrease_timer = Timer.new()
	health_decrease_timer.wait_time = 0.5
	health_decrease_timer.one_shot = false
	add_child(health_decrease_timer)
	health_decrease_timer.connect("timeout", _on_health_decrease_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_inside = true
		health_decrease_timer.start()
		handle_player_collision(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_inside = false
		health_decrease_timer.stop()
				
func handle_player_collision(body):
	var x_delta = body.position.x - position.x
	
	print("Decrease player health")
	game_manager.decrease_health()
	
	if x_delta > 0:
		body.jump_slide(500) #push to the right
	else:
		body.jump_slide(-500) #push to the left
	
	if position.y - body.position.y > 14:
		print("player jumps")
		body.jump()
		
func _on_health_decrease_timer_timeout():
	if player_inside:
		print("Decrease player health")
		game_manager.decrease_health()


		
