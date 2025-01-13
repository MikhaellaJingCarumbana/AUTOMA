extends State


# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("Run")
	
	can_transition = false
	await get_tree().create_timer(0.5).timeout
	can_transition = true
	
func exit():
	super.exit()
	owner.set_physics_process(false)
	
func transition():
	
	if not can_transition:
		return
		
	var distance = owner.direction.length()
	print(distance)
	if distance < 50:
		get_parent().change_state("Slash 1")
	elif distance > 300:
		print("Dashing")
		get_parent().change_state("Glitch Out")
