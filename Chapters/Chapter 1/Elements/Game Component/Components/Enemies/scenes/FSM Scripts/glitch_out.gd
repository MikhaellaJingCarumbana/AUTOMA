extends State

@onready var map_bounds: CollisionShape2D = $Map_bounds/CollisionShape2D
var can_transition1: bool = false
# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	animation_player.play("glitch out")
	await dash()
	can_transition1 = true


func dash():
	var tween = create_tween()

	tween.tween_property(owner, "position", Vector2(player.position.x, player.position.y), 0.5)
	await tween.finished
	
	
func transition():
	if can_transition1:
		can_transition1 = false
		
		get_parent().change_state("Run")
