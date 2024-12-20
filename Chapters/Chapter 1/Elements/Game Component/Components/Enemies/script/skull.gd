extends CharacterBody2D
class_name SkullEnemy

@onready var game_manager: Node = %GameManager
@export var note_scene: PackedScene
@export var enemy_type: String = "Skull"
var group_id = null
var grouped: bool = false

const speed = 30 
var is_cyclops_chase: bool = true


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

@export var hover_height: float = 10.0



func _ready():
	position.y -= hover_height
	
	if game_manager.has_method("add_enemy_to_group"):
		game_manager.add_enemy_to_group("Skull", self)
	print("DEBUG: Enemy added to group manager.")
	
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
			anim_sprite.play("death")
			await get_tree().create_timer(1,0).timeout
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
		
	if grouped and game_manager.has_method("kill_group"):
		game_manager.kill_group(group_id)
	else:
		queue_free()
		
	self.queue_free()
	print("Enemy has been freed")
	
	

func move(delta):
	if !dead:
		if !is_cyclops_chase:
			velocity += dir * speed * delta
		elif is_cyclops_chase and !taking_damage:
			var dir_to_player = position.direction_to(player.position) * speed
			velocity.x = dir_to_player.x
			dir.x = abs(velocity.x)/velocity.x
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
		print(y_delta)
		if(y_delta > 14):
			print("Destroy enemy")
			handle_death()
			body.jump()
		else:
			print("Decrease player health")
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
	
	if group_id >= 0 and game_manager.has_method("apply_damage_to_group"):
		game_manager.apply_damage_to_group(enemy_type, group_id, amount)
	print("DEBUG: Enemy took damage. Current health: ", health)
	
	if health <= 0:
		handle_death()
		
	
		
func set_grouped_visuals(grouped_status: bool):
	grouped = grouped_status
	if grouped:
		%AnimatedSprite2D.modulate = Color(1, 0.5, 0.5)
	else:
		%AnimatedSprite2D.modulate = Color(1,1,1)
		

				
	#github streak saver hahaha
