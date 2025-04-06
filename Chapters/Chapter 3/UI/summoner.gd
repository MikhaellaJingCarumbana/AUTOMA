extends Area2D

var has_summoned := false
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	anim.visible = false
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.name == "Player" and not has_summoned:
		has_summoned = true
		anim.visible = true
		anim.play("Summon")

		await anim.animation_finished
		anim.play("Idle")
