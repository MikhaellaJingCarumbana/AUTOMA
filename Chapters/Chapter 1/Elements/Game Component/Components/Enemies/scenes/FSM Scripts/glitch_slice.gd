extends State

var can_tranistion1: bool = false
var dash_speed = 700
var dash_distance = 200
var is_dashing = false
@export var dash_offset: Vector2 = Vector2(-50, 0)
@onready var map_bounds: CollisionShape2D = $Map_bounds/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	animation_player.play("glitch out")
	await dash()
	await get_tree().create_timer(0.5).timeout
	can_tranistion1 = true

func dash():
	var tween = create_tween()
	
	
func transition():
	if can_tranistion1:
		can_tranistion1 = false
		
	get_parent().change_state("Run")
