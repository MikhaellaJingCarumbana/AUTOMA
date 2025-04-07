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

		# Connect to the Dialogic signal
		Dialogic.connect("timeline_ended", Callable(self, "_on_dialogue_finished"))
		Dialogic.start("Final dialogue")


func _on_dialogue_finished(timeline_name):
	if timeline_name == "Final dialogue":
		# Wait for the timeline to end and then play the vanish animation
		Dialogic.disconnect("timeline_ended", Callable(self, "_on_dialogue_finished"))  # Clean up the connection
		# You can also connect to the animation_finished signal to trigger the vanish animation
		await anim.play("Vanish")
		
	
func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		# Trigger the vanish animation when the player exits
		anim.play("Vanish")
		# Wait for the animation to finish before hiding the sprite
		await anim.animation_finished
		anim.visible = false  # Hide the sprite after animation finishes
