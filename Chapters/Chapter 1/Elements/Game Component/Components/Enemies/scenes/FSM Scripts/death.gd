extends State

@onready var boss_music: AudioStreamPlayer2D = $"../../Boss Music"

# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	animation_player.play("dead")
	await animation_player.animation_finished
	boss_music.stop()
	#play the death screen
