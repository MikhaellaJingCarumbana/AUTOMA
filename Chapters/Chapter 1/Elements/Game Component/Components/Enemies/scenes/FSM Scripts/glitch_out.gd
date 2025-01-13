extends State

var dash_speed = 1000
var dash_distance = 200
var is_dashing = false
@export var dash_offset: Vector2 = Vector2(-50, 0)
var animation_finished: bool = false

var can_transition1: bool = false
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("glitch out")
	await dash()
	can_transition1 = true

	
	
func dash(): 
	
	var target_position = player.position
	
	if target_position.y > owner.position.y:
		target_position.y = owner.position.y
		
	var tween = create_tween()
	
	tween.tween_property(owner, "position", target_position, 0.8)
	
	
func transition():
	if animation_player.is_playing():
		return
		
	if can_transition1:
	
		var distance = owner.direction.length()
		
		get_parent().change_state("Glitch Sweep")
		if distance < 60:
			get_parent().change_state("Slash 2")
		elif distance > 60 and distance < 100:
			get_parent().change_state("Run")
		elif distance > 120:
			get_parent().change_state("Glitch Slice")

		
