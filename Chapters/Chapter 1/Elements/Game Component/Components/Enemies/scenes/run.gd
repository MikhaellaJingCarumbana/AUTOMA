extends State

var attack: bool = false
func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("run")

func exit():
	super.exit()
	owner.set_physics_process(false)
	
func transition():
	
	var distance = owner.position.length()
	
	if attack:
		attack = false
		get_parent().change_state("Slash 1")

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		attack = true
		
