extends State


# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("Idle Glitch")
	owner.in_attack_state = false
	
func exit():
	super.exit()
	owner.set_physics_process(false)
	
func transition():
	await get_tree().create_timer(0.5).timeout
	get_parent().change_state("Run")

	
