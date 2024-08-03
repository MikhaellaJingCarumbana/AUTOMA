extends Button

@export var angle_x_max: float = 15.0
@export var angle_y_max: float = 15.0
@export var max_offset_shadow: float = 50.0

@export_category("Oscillator")
@export var spring: float = 150.0
@export var damp: float = 10.0
@export var velocity_multiplier: float = 2.0

@export var line_color: Color = Color(1, 0, 0)  # Editable Line2D color
@export var arrowhead_color: Color = Color(1, 0, 0)  # Editable Arrowhead color
@export var arrowhead_width: float = 20.0
@export var arrowhead_height: float = 10.0

var displacement: float = 0.0 
var oscillator_velocity: float = 0.0

var tween_rot: Tween
var tween_hover: Tween
var tween_destroy: Tween
var tween_handle: Tween

var last_mouse_pos: Vector2
var mouse_velocity: Vector2
var following_mouse: bool = false
var last_pos: Vector2
var velocity: Vector2

var line_active = false  # Flag to check if the line is active
var line_active2 = false

@onready var card_texture: TextureRect = $CardTexture
@onready var shadow = $Shadow
@onready var collision_shape = $DestroyArea/CollisionShape2D
@onready var line2d = $Line2D
@onready var line2d2 = $Line2D2
@onready var arrowhead = $Arrowhead
@onready var arrowhead2 = $Arrowhead2
@onready var start_button = $StartButton
@onready var end_button = $EndButton
@onready var start_button2 = $StartButton2
@onready var end_button2 = $EndButton2

func _ready() -> void:
	angle_x_max = deg_to_rad(angle_x_max)
	angle_y_max = deg_to_rad(angle_y_max)
	collision_shape.set_deferred("disabled", true)

	# Initialize line
	line2d.width = 4.0
	line2d.default_color = line_color  # Set the initial color for Line2D
	line2d.clear_points()
	line2d.add_point(Vector2.ZERO)
	line2d.add_point(Vector2.ZERO)
	
	line2d2.width = 4.0
	line2d2.default_color = line_color  # Set the initial color for Line2D2
	line2d2.clear_points()
	line2d2.add_point(Vector2.ZERO)
	line2d2.add_point(Vector2.ZERO)
	
	# Initialize arrowheads
	arrowhead.visible = false
	update_arrowhead_shape(arrowhead)
	arrowhead.modulate = arrowhead_color  # Set the initial color for Arrowhead

	arrowhead2.visible = false
	update_arrowhead_shape(arrowhead2)
	arrowhead2.modulate = arrowhead_color  # Set the initial color for Arrowhead2


	# Start updating line points in _process
	set_process(true)

func _process(delta: float) -> void:
	rotate_velocity(delta)
	follow_mouse(delta)
	handle_shadow(delta)
	if Global.get_active_line() == line2d:
		update_line_points(line2d, arrowhead, start_button, end_button)
	elif Global.get_active_line() == line2d2:
		update_line_points(line2d2, arrowhead2, start_button2, end_button2)

func destroy() -> void:
	card_texture.use_parent_material = true
	if tween_destroy and tween_destroy.is_running():
		tween_destroy.kill()
	tween_destroy = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_destroy.tween_property(material, "shader_parameter/dissolve_value", 0.0, 2.0).from(1.0)
	tween_destroy.parallel().tween_property(shadow, "self_modulate:a", 0.0, 1.0)

func rotate_velocity(delta: float) -> void:
	if not following_mouse: return
	var center_pos: Vector2 = global_position - (size / 2.0)
	velocity = (position - last_pos) / delta
	last_pos = position
	oscillator_velocity += velocity.normalized().x * velocity_multiplier
	var force = -spring * displacement - damp * oscillator_velocity
	oscillator_velocity += force * delta
	displacement += oscillator_velocity * delta
	rotation = displacement

func handle_shadow(delta: float) -> void:
	var center: Vector2 = get_viewport_rect().size / 2.0
	var distance: float = global_position.x - center.x
	shadow.position.x = lerp(0.0, -sign(distance) * max_offset_shadow, abs(distance / center.x))

func follow_mouse(delta: float) -> void:
	if not following_mouse: return
	var mouse_pos: Vector2 = get_global_mouse_position()
	global_position = mouse_pos - (size / 2.0)

func handle_mouse_click(event: InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	if event.is_pressed():
		following_mouse = true
	else:
		following_mouse = false
		collision_shape.set_deferred("disabled", false)
		if tween_handle and tween_handle.is_running():
			tween_handle.kill()
		tween_handle = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween_handle.tween_property(self, "rotation", 0.0, 0.3)

func _on_gui_input(event: InputEvent) -> void:
	handle_mouse_click(event)
	if following_mouse: return
	if not event is InputEventMouseMotion: return
	var mouse_pos: Vector2 = get_local_mouse_position()
	var diff: Vector2 = (position + size) - mouse_pos
	var lerp_val_x: float = remap(mouse_pos.x, 0.0, size.x, 0, 1)
	var lerp_val_y: float = remap(mouse_pos.y, 0.0, size.y, 0, 1)
	var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))
	card_texture.material.set_shader_parameter("x_rot", rot_y)
	card_texture.material.set_shader_parameter("y_rot", rot_x)

func _on_mouse_entered() -> void:
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2(1.2, 1.2), 0.5)

func _on_mouse_exited() -> void:
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
	tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween_rot.tween_property(card_texture.material, "shader_parameter/x_rot", 0.0, 0.5)
	tween_rot.tween_property(card_texture.material, "shader_parameter/y_rot", 0.0, 0.5)
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2.ONE, 0.55)

func _on_start_button_pressed() -> void:
	if Global.get_active_line() == line2d:
		clear_line(line2d, arrowhead)
	else:
		var button_center = get_start_button_position(start_button)
		line2d.clear_points()
		line2d.add_point(line2d.to_local(button_center))
		line2d.add_point(line2d.to_local(button_center))  # Initialize end point to start point
		Global.set_active_line(line2d)  # Pass only the line2d
		line_active = true
		arrowhead.visible = true  # Show arrowhead when line is active
		print("Line started at: ", button_center)  # Debug line start
		print("Start button position: ", button_center)  # Debug start button position

func _on_end_button_pressed() -> void:
	if Global.get_active_line() == line2d:
		Global.set_end_button(end_button)
		line_active = false  # Set the line_active flag to false when end_button is pressed
		print("Line ended at: ", end_button.global_position)  # Debug line end
		print("End button position: ", get_end_button_position(end_button))  # Debug end button position
		arrowhead.visible = false  # Hide arrowhead when line is finalized
		Global.set_active_line(null)  # Deactivate the line after ending it

func _on_start_button_2_pressed() -> void:
	if Global.get_active_line() == line2d2:
		clear_line(line2d2, arrowhead2)
	else:
		var button_center = get_start_button_position(start_button2)
		line2d2.clear_points()
		line2d2.add_point(line2d2.to_local(button_center))
		line2d2.add_point(line2d2.to_local(button_center))  # Initialize end point to start point
		Global.set_active_line(line2d2)  # Pass only the line2d2
		line_active2 = true
		arrowhead2.visible = true  # Show arrowhead when line is active
		print("Line2 started at: ", button_center)  # Debug line2 start
		print("Start button2 position: ", button_center)  # Debug start button2 position

func _on_end_button_2_pressed() -> void:
	if Global.get_active_line() == line2d2:
		Global.set_end_button(end_button2)
		line_active2 = false  # Set the line_active2 flag to false when end_button2 is pressed
		print("Line2 ended at: ", end_button2.global_position)  # Debug line2 end
		print("End button2 position: ", get_end_button_position(end_button2))  # Debug end button2 position
		arrowhead2.visible = false  # Hide arrowhead2 when line2 is finalized
		Global.set_active_line(null)  # Deactivate the line2 after ending it

func clear_line(line, arrowhead) -> void:
	line.clear_points()
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2.ZERO)
	arrowhead.visible = false  # Hide the arrowhead when the line is cleared

func update_line_points(line, arrowhead, start_button, end_button) -> void:
	if line_active:
		var button_center = get_start_button_position(start_button)
		line.set_point_position(0, line.to_local(button_center))
		var end_pos = get_global_mouse_position()
		line.set_point_position(1, line.to_local(end_pos))
		update_arrowhead_position(arrowhead, line, end_pos)
	elif line_active2:
		var button_center2 = get_start_button_position(start_button2)
		line.set_point_position(0, line.to_local(button_center2))
		var end_pos2 = get_global_mouse_position()
		line.set_point_position(1, line.to_local(end_pos2))
		update_arrowhead_position(arrowhead, line, end_pos2)

func get_start_button_position(button) -> Vector2:
	return button.get_global_transform().origin

func get_end_button_position(button) -> Vector2:
	return button.get_global_transform().origin

func update_arrowhead_shape(arrowhead) -> void:
	var points = PackedVector2Array()
	points.append(Vector2(0, -arrowhead_height / 2))
	points.append(Vector2(arrowhead_width, 0))
	points.append(Vector2(0, arrowhead_height / 2))
	arrowhead.polygon = points

func update_arrowhead_position(arrowhead, line, end_pos) -> void:
	arrowhead.global_position = end_pos
	var direction = (line.get_point_position(1) - line.get_point_position(0)).normalized()
	arrowhead.rotation = direction.angle()

#working but won't connect to endbuttons
