extends State

@onready var map_bounds: CollisionShape2D = $Map_bounds/CollisionShape2D
var dash_speed = 700
var dash_distance = 200
var is_dashing = false
@export var dash_offset: Vector2 = Vector2(-50, 0)

var can_transition1: bool = false
# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	animation_player.play("glitch out")
	await dash()
	can_transition1 = true

func dash():
	var tween = create_tween()
	
	var target_position = owner.position + (direction.normalized() * dash_distance)
	tween.tween_property(owner, "position", target_position, 0.1)
	await tween.finished
	
func transition():
	if can_transition1:
		can_transition1 = false
		get_parent().change_state("Run")
