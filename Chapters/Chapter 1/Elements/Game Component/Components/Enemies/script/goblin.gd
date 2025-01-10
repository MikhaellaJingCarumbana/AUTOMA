extends CharacterBody2D
class_name Goblin

@onready var game_manager: Node = %GameManager
@export var note_scene: PackedScene
@export var group_type: String = "Skull"
var group_id = null
var grouped: bool = false
@onready var anim: AnimatedSprite2D = %AnimatedSprite2D

const speed = 100
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

var player: CharacterBody2D
var player_in_area = false
@export var death_sound: AudioStream
@onready var cackle: AudioStreamPlayer2D = $cackle
@onready var sfx_player: AudioStreamPlayer2D = %sfx_player



var in_collision_area: bool = false
@onready var roaming_timer: Timer = $Roaming_timer
@onready var direction_timer: Timer = $DirectionTimer

signal died(group_id: int)

func _ready():
	cackle.play()
	anim.play("walk")
	roaming_timer.start()

func _process(delta):
	player = Global.playerBody
	move(delta)
	handle_animation()
	move_and_slide()
	

func handle_animation():
	if !dead:
		if player_in_area:
			if !taking_damage and !is_dealing_damage:
				anim.play("run")
				if dir.x == -1:
					anim.flip_h = true
				elif dir.x == 1:
					anim.flip_h = false
		elif velocity.x == 0:
			anim.play("idle")
	elif dead and is_roaming:
		is_roaming = false
		anim.play("death")
		load_sfx(death_sound)
		sfx_player.play()
		handle_death()



func handle_death():
	print("DEBUG: handle_death called for ", self.name)
	dead = true
	velocity = Vector2.ZERO
	is_cyclops_chase = false
	is_roaming = false
	
	
	var note = get_parent().get_node_or_null("Note")
	if note:
		note.visible = true
		note.set_collision_layer_value(0, true)
		note.set_collision_mask_value(0, true)
		print("DEBUG: Note made visible and collidable at position: ", note.global_position)
	else:
		print("DEBUG: No note node found under the same parent as enemy.")
		
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D.set_deferred("monitoring", false)
	$Area2D.set_deferred("monitorable", false)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	
	anim.play("death")
	load_sfx(death_sound)
	sfx_player.play()
	var death_animation_length = anim.sprite_frames.get_frame_count("death") / anim.sprite_frames.get_animation_speed("death")
	await get_tree().create_timer(death_animation_length).timeout
	
	
	print("DEBUG: Death animation finished. Freeing enemy.")
	queue_free()

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
	velocity.y += gravity * delta
	if dead:
		velocity = Vector2.ZERO
		return
		
	if !dead:
		if player_in_area:
			if is_cyclops_chase and !taking_damage:
				var dir_to_player = position.direction_to(player.position) * speed
				velocity.x = dir_to_player.x
				dir.x = abs(velocity.x)/velocity.x
			else:
				velocity.y += gravity * delta
				velocity += dir * speed * delta
		else:
			velocity = Vector2.ZERO
		is_roaming = true
	elif dead:
			velocity.x = 0
			velocity.y += gravity * delta
		

func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = choose([1.5, 2.0, 2.5])
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
		if (y_delta > 7):
			print("Destroy enemy")
			anim.play("deal_damage")
			handle_death()
			body.jump()
		elif y_delta < -7:
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
	print("DEBUG: Enemy took damage. Current health: ", health)
	if health <= 0:
		handle_death()

func load_sfx(sfx_to_load):
	if %sfx_player.stream != sfx_to_load:
		%sfx_player.stop()
		%sfx_player.stream = sfx_to_load
