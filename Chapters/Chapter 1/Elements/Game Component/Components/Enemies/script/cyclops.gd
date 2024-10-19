extends CharacterBody2D

class_name CyclopsEnemy

const speed = 10 
var is_cyclops_chase: bool


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

func _process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
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
