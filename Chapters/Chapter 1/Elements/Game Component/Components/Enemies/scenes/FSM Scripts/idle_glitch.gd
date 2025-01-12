extends State


# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("Idle Glitch")
	
	
func transition():
	var distance = owner.direction.length()
	if distance > 120:
		await get_tree().create_timer(0.4).timeout
		get_parent().change_state("Glitch Slice")
	
