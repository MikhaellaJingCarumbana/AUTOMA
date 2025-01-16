extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("Intro card draw")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass


func _on_chapter_1_mouse_entered() -> void:
	animation_player.play("chapter 1")
	

func _on_chapter_2_mouse_entered() -> void:
	animation_player.play("chapter 2")
	

func _on_chapter_3_mouse_entered() -> void:
	animation_player.play("chapter 3")
	

func _on_chapter_1_mouse_exited() -> void:
	animation_player.play("chapter 1_2")
	


func _on_chapter_2_mouse_exited() -> void:
	animation_player.play("chapter 2_2")
	

func _on_chapter_3_mouse_exited() -> void:
	animation_player.play("chapter 3_2")
