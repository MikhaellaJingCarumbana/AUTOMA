extends Button

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var chapters_animation: Control = $"../.."
@onready var sfx: AudioStreamPlayer2D = $sfx

# Called when the node enters the scene tree for the first time.

func _on_mouse_entered() -> void:
    if chapters_animation.animation_finished:
        animation_player.play("flip")
        sfx.play()



func _on_mouse_exited() -> void:
    animation_player.play("flip_2")
    sfx.play()
