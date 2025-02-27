extends CharacterBody2D
class_name SkullEnemy

@onready var game_manager: Node = %GameManager
@export var note_scene: PackedScene
@export var group_type: String = "Skull"
var group_id = null
var grouped: bool = false
@onready var anim: AnimatedSprite2D = %AnimatedSprite2D

const speed = 50
const base_speed = 40 
const max_speed = 120
var current_speed = base_speed
var is_cyclops_chase: bool = false
var player_chase_time = 0.0


#health
var health = 80
var health_max = 80
var health_min = 0


var dead : bool = false

var taking_damage : bool = false
var damage_to_deal = 10
var is_dealing_damage : bool = false

var dir: Vector2
const gravity = 900
var knocback_force = 200
var is_roaming: bool = true
const float_speed = 2.0
const float_amplitude = 10.0
var float_time: float = 0.0

var player: CharacterBody2D
var player_in_area = false
@export var death_sound: AudioStream
@onready var sfx_player: AudioStreamPlayer2D = %sfx_player
@onready var whisper: AudioStreamPlayer2D = $whisper



@export var hover_height: float = 10.0

signal died(group_id: int)

func _ready():
	whisper.play()
	anim.play("walk")
	position.y -= hover_height
	
	
func _process(delta):
	float_time += delta
	position.y += sin(float_time * float_speed) * float_amplitude * delta
		
	player = Global.playerBody
	move(delta)
	handle_animation()
	move_and_slide()
	
func handle_animation():
	var anim_sprite = %AnimatedSprite2D
	if !dead and !taking_damage and !is_dealing_damage:
		anim_sprite.play("walk")
		if dir.x == -1:
			anim_sprite.flip_h = true
		elif dir.x == 1:
			anim_sprite.flip_h = false
		elif !dead and taking_damage and !is_dealing_damage:
			anim_sprite.play("hurt")
			await get_tree().create_timer(1.0).timeout
			taking_damage = false
		elif dead and is_roaming:
			is_roaming = false
			
			handle_death()
			
func handle_death():
	print("DEBUG: handle_death called for ", self.name)
	var note = get_parent().get_node_or_null("Note")
	if note:
		note.visible = true
		note.set_collision_layer_value(0, true)
		note.set_collision_mask_value(0, true)
		print("DEBUG: Note made visible and collidable at position: ", note.global_position)
	else:
		print("DEBUG: No note node found under the same parent as enemy.")
		
	load_sfx(death_sound)
	anim.play("death")
	sfx_player.play()
	await get_tree().create_timer(0.3).timeout
	self.queue_free()
	print("Enemy has been freed")
	

func _on_chase_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_cyclops_chase = true
		player_in_area = true
		print("PLAYER ENTERED CHASE AREA!!!")


func _on_chase_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_cyclops_chase = false
		player_in_area = false
		print("PLAYER EXITED CHASE AREA!!!")


func move(delta):
	if !dead:
		if !is_cyclops_chase:
			velocity += dir * speed * delta
		elif is_cyclops_chase and !taking_damage:
			
			player_chase_time += delta
			
			current_speed = lerp(base_speed, max_speed, player_chase_time / 5.0)
			current_speed = clamp(current_speed, base_speed, max_speed)
			
			var dir_to_player = position.direction_to(player.position)
			
			var random_offset = Vector2(
				randf_range(-0.2, 0.2),
				randf_range(-0.2, 0.2)
			)
			
			dir_to_player += random_offset
			dir_to_player = dir_to_player.normalized()
			
			velocity = dir_to_player * speed
			dir.x = sign(velocity.x)
			
		is_roaming = true
	elif dead:
		velocity.x = 0
		
		
			
func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = choose([1.5,2.0, 2.5])
	if !is_cyclops_chase:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0
	
func choose(array):
	array.shuffle()
	return array.front()


func _on_area_2d_body_entered(body):
	if (body.name == "Player"):
		var y_delta = position.y - body.position.y
		var x_delta = body.position.x - position.x
		
		print("y_delta:", y_delta, "x_delta:", x_delta)
		
		if(y_delta > 7):
			print("Destroy enemy")
			anim.play("deal_damage")
			handle_death()
			body.jump()
			
		elif y_delta <  -7:
			print("Player hit the bottom of the skull! Damaging player.")
			anim.play("deal_damage")
			game_manager.decrease_health()
			
			body.velocity.y += 300 
			body.jump_slide(x_delta * 2)
			
			is_cyclops_chase = false
			await get_tree().create_timer(0.5).timeout
			is_cyclops_chase = true
			
		else:
			print("Decrease player health")
			anim.play("deal_damage")
			game_manager.decrease_health()
			if (x_delta > 0):
				body.jump_slide(500)
			else:
				body.jump_slide(-500)
				
func take_damage(amount: int):
	health -= amount
	var anim_sprite = %AnimatedSprite2D
	anim_sprite.play("hurt")
	print("DEBUG: Enemy took damage. Current health: ", health)
	
	
	if health <= 0:
		handle_death()
		
func load_sfx(sfx_to_load):
	if %sfx_player.stream != sfx_to_load:
		%sfx_player.stop()
		%sfx_player.stream = sfx_to_load
				
	
		
