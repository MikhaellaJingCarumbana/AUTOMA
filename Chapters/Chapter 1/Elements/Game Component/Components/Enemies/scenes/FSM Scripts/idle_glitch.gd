extends State


# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("Idle Glitch")
	
func transition():
	var distance = owner.direction.length()
	if distance < 100:
		get_parent().change_state("Run")
	else:
		get_parent().change_state("Glitch Out")
	
