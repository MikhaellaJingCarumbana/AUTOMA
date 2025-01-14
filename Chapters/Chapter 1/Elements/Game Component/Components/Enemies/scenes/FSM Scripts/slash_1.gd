extends State

var animation_finished: bool = false
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var in_attack_state: bool = false
var damage_cooldown: float = 0.5
var last_damage_time: float = -1
# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("Slash 1")
	in_attack_state = true
	owner.in_attack_state = true
	
	
	
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
		
	var distance = owner.direction.length()
	if distance > 100:
		get_parent().change_state("Run")
	elif distance < 70:
		get_parent().change_state("Slash 2")
		
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player entered")
		if owner.in_attack_state:
			body.take_damage()
			print("In attack state: ", owner.in_attack_state)
