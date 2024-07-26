extends Node2D

@export var line_color: Color = Color(1, 0, 0)
@export var line_width: float = 4.0
@export var arrowhead_width: float = 20.0  # Adjusted width for a wider arrowhead
@export var arrowhead_height: float = 10.0  # Adjusted height for a shallower arrowhead

@onready var line = $Line2D
@onready var arrowhead = $Arrowhead

var points = []

func _ready():
	line.width = line_width
	line.default_color = line_color
	line.add_point(Vector2.ZERO)  # Initial point, so we have two points to manipulate
	line.add_point(Vector2.ZERO)  # Second point

	# Set up the arrowhead shape
	update_arrowhead_shape()
	arrowhead.visible = false  # Initially hide the arrowhead

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
			if points.size() < 2:
				points.append(event.position)
				if points.size() == 1:
					line.set_point_position(0, event.position)
				elif points.size() == 2:
					line.set_point_position(1, event.position)
					update_arrowhead_position()

	elif event is InputEventMouseMotion and points.size() == 1:
		line.set_point_position(1, event.position)
		update_arrowhead_position()

	elif event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_RIGHT and event.pressed:
		clear_line()

func clear_line():
	points.clear()
	line.set_point_position(0, Vector2.ZERO)
	line.set_point_position(1, Vector2.ZERO)
	arrowhead.visible = false

func update_arrowhead_shape():
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
