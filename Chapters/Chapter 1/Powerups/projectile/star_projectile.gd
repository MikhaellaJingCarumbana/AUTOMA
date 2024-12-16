extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var speed: float = 400
@export var lifespan: float = 5.0
@export var damage: int = 40

func initialize(direction: Vector2):
	velocity = direction * speed
	
func _process(delta):
	position += velocity * delta
	
	lifespan -= delta
	if lifespan <= 0:
		queue_free() 
		
	
func _physics_process(delta: float) -> void:
	animated_sprite_2d.play("default")
	position += velocity * delta
	if position.x < 0 or position.x > 800:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is SkullEnemy:
		body.take_damage(damage)
		queue_free()
