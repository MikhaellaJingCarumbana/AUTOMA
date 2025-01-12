extends State

var can_tranistion1: bool = false
@onready var map_bounds: CollisionShape2D = $Map_bounds/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	animation_player.play("glitch out")
	await dash()
	can_tranistion1 = true

func dash():
	var tween = create_tween()

	tween.tween_property(owner, "position", Vector2(player.position.x, player.position.y), 0.5)
	await tween.finished

func transition():
	if can_tranistion1:
		can_tranistion1 = false
		
	get_parent().change_state("Run")
