extends State

@onready var collision: CollisionShape2D = $"../../Player Detection/CollisionShape2D"
@onready var progress_bar = owner.find_child("ProgressBar")

var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled", value)
		progress_bar.set_deferred("visible", value)
		
func transition():
	if player_entered:
		get_parent().change_state("Run")


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_entered = true
		health.play("Healthbar")
