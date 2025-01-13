extends Node2D


# Called when the node enters the scene tree for the first time.
@onready var boss_music: AudioStreamPlayer2D = $"Boss music"


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		boss_music.play()
