extends State

var animation_finished: bool = false


# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("Slash 1")
	
	
func transition():
	if animation_player.is_playing():
		return
		
	var distance = owner.direction.length()
	if distance > 100:
		get_parent().change_state("Run")
	elif distance < 70:
		get_parent().change_state("Slash 2")


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player health decreased")
		body.take_damage()
