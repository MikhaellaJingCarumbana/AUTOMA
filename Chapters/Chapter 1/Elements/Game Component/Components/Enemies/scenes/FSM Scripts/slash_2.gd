extends State

var animation_finished: bool = false

# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("Slash 2")
	
func exit():
	super.exit()
	owner.set_physics_process(false)

func transition():
	get_parent().change_state("Idle Glitch")
	
			
