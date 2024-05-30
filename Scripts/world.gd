extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print("world is ready")
	Dialogic.start("test")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
