extends State


func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("run")

func exit():
	super.exit()
	owner.set_physics_process(false)
	
func transition():
	
	var distance = owner.position.length()
	print(distance)
	
	if distance < 650:
		print("Change to attack 1")
		get_parent().change_state("Attack 1")
