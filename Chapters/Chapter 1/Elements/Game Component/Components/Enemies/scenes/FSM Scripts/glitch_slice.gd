extends State

var dash_speed = 700
var dash_distance = 200
var is_dashing = false
@export var dash_offset: Vector2 = Vector2(-50, 0)
@onready var map_bounds: CollisionShape2D = $Map_bounds/CollisionShape2D

var can_transition1: bool = false
var animation_finished: bool = false

var in_attack_state: bool = false
var damage_cooldown: float = 0.5
var last_damage_time: float = -1

# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	animation_player.play("glitch slice")
	await dash()
	can_transition1 = true
	in_attack_state = true

func dash():

	var target_position = player.position
	
	if target_position.y > owner.position.y:
		target_position.y = owner.position.y
		
	var tween = create_tween()
	
	tween.tween_property(owner, "position", target_position, 0.8)
	
	
func transition():
	if animation_player.is_playing():
		return
		
	var overlapping_bodies = $"../../attack_Area".get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.is_in_group("Player") and owner.in_attack_state:
			var current_time = Time.get_ticks_msec() / 1000.0
			if current_time - last_damage_time >= damage_cooldown:
				body.take_damage()
				print("Player takes damage from overlapping in Slash 1")
		
	if can_transition1: 
		
		var distance = owner.direction.length()
		if distance < 60:
			get_parent().change_state("Glitch Sweep")
		elif distance >= 60:
			get_parent().change_state("Glitch Out")
		
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player entered")
		if owner.in_attack_state:
			print("In attack state: ", owner.in_attack_state)
			body.take_damage()
