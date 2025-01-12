extends State

var dash_speed = 700
var dash_distance = 200
var is_dashing = false
@export var dash_offset: Vector2 = Vector2(-50, 0)
@onready var map_bounds: CollisionShape2D = $Map_bounds/CollisionShape2D

var can_transition1: bool = false

# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	animation_player.play("glitch slice")
	owner.set_physics_process(true)
	await dash()
	can_transition1 = false

func dash():
	is_dashing = true
	var target_position = player.position
	
	if target_position.y > owner.position.y:
		target_position.y = owner.position.y
		
	var tween = create_tween()
	
	tween.tween_property(owner, "position", target_position, 0.8)
	await tween.finished
	is_dashing = false
	
	
func transition():
	if can_transition1 and not is_dashing:
		can_transition1 = false
		print("Transition to Slash 1")
		get_parent().change_state("Slash 1")
		


	
