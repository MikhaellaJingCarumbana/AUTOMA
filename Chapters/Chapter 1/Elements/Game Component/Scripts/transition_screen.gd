extends CanvasLayer

signal on_transition_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func _ready():
	if color_rect != null:
		color_rect.visible = false

	if animation_player != null:
		animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		on_transition_finished.emit()
		if animation_player != null:
			animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		if color_rect != null:
			color_rect.visible = false

func transition():
	if color_rect != null:
		color_rect.visible = true

	if animation_player != null:
		animation_player.play("fade_to_black")
