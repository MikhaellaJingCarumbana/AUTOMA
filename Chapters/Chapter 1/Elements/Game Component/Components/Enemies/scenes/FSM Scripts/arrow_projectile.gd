extends Area2D


var direction = Vector2.RIGHT
var speed = 300

func _ready() -> void:
	$AnimationPlayer.play("light")

func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	
	print("Projectile hit: ", body.name, "( Type: ", body.get_class(), ")")
	if body.is_in_group("ShadowBoss"):
		body.take_damage()
	else:
		print("Hit detected but not on boss")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
