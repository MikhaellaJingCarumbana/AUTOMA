extends Area2D


var direction = Vector2.RIGHT
var speed = 300

func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Boss"):
		body.take_damage()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
