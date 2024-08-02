extends Line2D

# Reference to the global manager
var global_manager: Node

func _ready():
	# Get the global manager (assumed to be a singleton or in the scene tree)
	global_manager = get_tree().root.get_node("/root/Global") # Adjust the path as needed

func update_line(start_pos: Vector2, end_pos: Vector2):
	# Update the points of the line
	self.points = [start_pos, end_pos]

func _on_StartButton_pressed():
	# Called when the start button is pressed
	var start_pos = global_manager.get_start_button().position
	self.update_line(start_pos, self.points[1]) # Assuming end position is already set

func _on_EndButton_pressed():
	# Called when the end button is pressed
	var end_pos = global_manager.get_end_button().position
	self.update_line(self.points[0], end_pos)
