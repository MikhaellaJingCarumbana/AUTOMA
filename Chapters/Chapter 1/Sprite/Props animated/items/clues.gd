extends Area2D

@export var clue_id: String
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	animated_sprite_2d.play("default")


func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player")):
		queue_free()
		
func trigger_event(clue_id: String) -> void:
	var game_manager = get_tree().root.get_node("GameManager")
	if game_manager:
		game_manager.clue_collected(clue_id)