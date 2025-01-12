extends State

var run: bool = false
var attack_finished = false
# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	animation_player.play("Slash 1")
	
	
func transition():
	if run:
		#print("Should go back to run")
		run = false
		get_parent().change_state("Run")

		
func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Should go back to run")
		run = true
		
