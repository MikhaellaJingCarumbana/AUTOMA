extends State


# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	animation_player.play("dead")
	await animation_player.animation_finished
	#play the death screen
