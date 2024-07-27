extends Node2D

@export var line_color: Color = Color(1, 0, 0)
@export var line_width: float = 4.0
@export var arrowhead_width: float = 20.0  # Adjusted width for a wider arrowhead
@export var arrowhead_height: float = 10.0  # Adjusted height for a shallower arrowhead

@onready var line = $Line2D
@onready var arrowhead = $Arrowhead
@onready var start_button = $Button  # The button that marks the start point

var points = []
var line_active = false  # Flag to check if the line is active
var dragging = false
var offset = Vector2.ZERO

func _ready():
	line.width = line_width
	line.default_color = line_color
	line.add_point(Vector2.ZERO)  # Initial point, so we have two points to manipulate
	line.add_point(Vector2.ZERO)  # Second point

	# Set up the arrowhead shape
	update_arrowhead_shape()
	arrowhead.visible = true  # Initially hide the arrowhead

	# Connect the button's pressed signal to the method

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.pressed:
				if start_button.get_rect().has_point(event.position):
					# Start dragging the button
					dragging = true
					offset = start_button.global_position - event.global_position
			else:
				# Stop dragging
				dragging = false
		elif event.button_index == MouseButton.MOUSE_BUTTON_RIGHT and event.pressed:
			clear_line()

	if dragging:
		# Update the button position while dragging
		start_button.global_position = event.global_position + offset
		# Update the line's start point to the center of the button
		update_line_start_point()

	if line_active and event is InputEventMouseMotion:
		line.set_point_position(1, get_viewport().get_mouse_position())
		update_arrowhead_position()

func _process(delta):
	if line_active:
		# Ensure the line's start point remains at the center of the button
		update_line_start_point()

func _on_button_pressed():
	if not line_active:
		# Calculate the center of the button
		var button_center = start_button.global_position + start_button.size / 2
		# Set the start point to the center of the button and activate the line
		points.clear()
		points.append(button_center)
		line.set_point_position(0, button_center)
		line.set_point_position(1, button_center)  # Initialize end point to the start point
		line_active = true
		arrowhead.visible = true  # Hide arrowhead until line is finalized
	else:
		# Deactivate the line and hide the arrowhead
		clear_line()

func clear_line():
	points.clear()
	line.set_point_position(0, Vector2.ZERO)
	line.set_point_position(1, Vector2.ZERO)
	arrowhead.visible = false

func update_arrowhead_shape() -> void:
	var half_width = arrowhead_width / 2
	var half_height = arrowhead_height / 2

	var arrowhead_points = PackedVector2Array([
		Vector2(0, -half_height),       # Tip of the arrow
		Vector2(-half_width, half_height),  # Left wing
		Vector2(half_width, half_height)  # Right wing
	])

	arrowhead.polygon = arrowhead_points

func update_arrowhead_position():
	if points.size() == 2:
		var start = points[0]
		var end = points[1]
		var direction = (end - start).normalized()
		var arrowhead_position = end - direction * (line_width / 2)
		arrowhead.position = arrowhead_position
		arrowhead.rotation = direction.angle() + PI / 2
		arrowhead.visible = true

func update_line_start_point():
	var button_center = start_button.global_position + start_button.size / 2
	line.set_point_position(0, button_center)
