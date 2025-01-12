extends State


# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("Run")
	
func exit():
	super.exit()
	owner.set_physics_process(false)
	
func transition():
	var distance = owner.direction.length()
	print(distance)
	
	if distance < 40:
		get_parent().change_state("Slash 1")
		
	if distance > 150:
		get_parent().change_state("Glitch Out")
