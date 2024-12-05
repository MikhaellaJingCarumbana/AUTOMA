extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var parent_enemy: NodePath
@onready var enemy: Node = get_node(parent_enemy)
@onready var game_manager: Node = $"../../GameManager"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#visible = false
	#set_visibility_layer_bit(0, true)
	#set_collision_mask_value(0, true)
	#print("DEBUG: Note initialized as invisible and non-collidable.")
	
	visible = true
	set_collision_layer_value(0, true)
	set_collision_mask_value(0, true)
	print("DEBUG: Note initialized as invisible and non-collidable.")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if enemy and enemy.dead:
		#visible = true
		#set_collision_layer_value(0, true)
		#set_collision_mask_value(0, true)
		#animated_sprite_2d.play("default")


func _on_body_entered(body: Node2D) -> void:
	print("DEBUG: Body entered Note area:", body.name)
	if visible and body.is_in_group("Player"):
		print("DEBUG: Player")
		queue_free()
		game_manager.add_note()
		print("DEBUG: Note collected and game manager updated.")
	elif not visible:
		print("DEBUG: Note is not visible; cannot be collected.")
