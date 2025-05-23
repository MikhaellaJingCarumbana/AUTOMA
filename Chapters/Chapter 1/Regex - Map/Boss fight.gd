extends Node2D

@onready var game_manager: Node = %GameManager
@onready var death: Node2D = $ShadowBoss/FiniteStateMachine/Death
# Called when the node enters the scene tree for the first time.
@onready var boss_music: AudioStreamPlayer2D = $"Boss music"

func _ready() -> void:
	add_child(game_manager.shoot_timer)
	add_child(game_manager.cooldown_timer)
	
func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		boss_music.play()
		$Player_healthbar.play("player_health")
		if death.is_dead:
			boss_music.stop()
		
