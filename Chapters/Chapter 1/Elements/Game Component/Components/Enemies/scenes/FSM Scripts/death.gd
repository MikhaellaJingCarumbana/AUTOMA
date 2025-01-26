extends State

@onready var boss_music: AudioStreamPlayer2D = $"../../Boss Music"
@onready var chapter_1_menu: Control = $UI/Chapter1Menu
@onready var transition_animation_player: AnimationPlayer = $AnimationPlayer
var is_dead: bool = false

# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	animation_player.play("dead")
	is_dead
	await animation_player.animation_finished
	await get_tree().create_timer(1.0).timeout
	
