extends State


# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	animation_player.play("attack 1")
	
func transition():
	if owner.direction.length() > 600:
		get_parent().change_state("Run")
