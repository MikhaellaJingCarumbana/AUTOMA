extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("transition")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skip"):
		animation_player.play("transition_2")
		
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "transition_2":
		get_tree().change_scene_to_packed(scene)
