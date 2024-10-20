extends CharacterBody2D
class_name CyclopsEnemy

@onready var game_manager: Node = %GameManager

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

var player: CharacterBody2D
var player_in_area = false


func _process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
		
	player = Global.playerBody
	move(delta)
	handle_animation()
	move_and_slide()
	
func handle_animation():
	var anim_sprite = $AnimatedSprite2D
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
	self.queue_free()

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
			queue_free()
			body.jump()
		else:
			print("Decrease player health")
			game_manager.decrease_health()
			if (x_delta > 0):
				body.jump_slide(500)
			else:
				body.jump_slide(-500)
