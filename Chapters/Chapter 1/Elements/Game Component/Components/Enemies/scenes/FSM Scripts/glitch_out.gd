extends State

@onready var map_bounds: CollisionShape2D = $Map_bounds/CollisionShape2D
var dash_speed = 1000
var dash_distance = 200
var is_dashing = false
@export var dash_offset: Vector2 = Vector2(-50, 0)

var can_transition1: bool = false
# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("glitch out")
	dash()
	
func exit():
	super.exit()
	owner.set_physics_process(false)
	
func dash():
	is_dashing = true
	var direction = (owner.player.position - owner.position).normalized()
	var dash_time = 0.2
	var dash_timer = 0.0
	
	var original_speed = owner.SPEED
	owner.SPEED = dash_speed
	
	while dash_timer < dash_timer:
		owner.position += direction * dash_speed * get_physics_process_delta_time()
		dash_timer += get_physics_process_delta_time()
		await get_tree().process_frame
	
	owner.SPEED = original_speed
	owner.velocity = Vector2.ZERO
	is_dashing = false
	
	can_transition1 = true
	
func transition():
	if not can_transition1:
		return
	can_transition1 = false
	
	get_parent().change_state("Slash 2")
