extends CanvasLayer

@export var effect_duration: float = 0.5
@export var fade_speed: float = 0.5
@onready var color_rect: ColorRect = $PlayerHurt/ColorRect
@onready var animation_player: AnimationPlayer = $PlayerHurt/AnimationPlayer

@export var hurt: AudioStream

var _is_active: bool = false
@onready var sfx_play: AudioStreamPlayer2D = %sfx_play

func show_hurt_effect():
	if color_rect.visible:
		color_rect.modulate.a = 1.0
		animation_player.stop()
		animation_player.play("blood")		
	else:
		color_rect.visible = true
		color_rect.modulate = Color(1, 0, 0, 1.0)  # Fully visible red
		animation_player.play("blood")
		
	fade_out()
	
func fade_out():
	while color_rect.modulate.a > 0.0:
		color_rect.modulate.a -= fade_speed * get_process_delta_time()
		await get_tree().process_frame
	color_rect.visible = false
	
