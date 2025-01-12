extends State

var animation_finished: bool = false

# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("Slash 1")
	
func transition():
	var distance = owner.direction.length()
	if distance > 50:
		get_parent().change_state("Run")
	

func _on_animated_sprite_2d_animation_finished(anim_name: String) -> void:
	if anim_name == "Slash 1":
		animation_finished = true
