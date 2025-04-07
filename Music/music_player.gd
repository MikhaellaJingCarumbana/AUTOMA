extends Node

@onready var music: AudioStreamPlayer = $AudioStreamPlayer

# Define the music that should play for the 3 specific scenes
var shared_music = preload("res://Music/Inspiring Fantasy Background Music For Videos_Enchanting Music_Medieval Fantasy_Atmospheric Ambience-yt.savetube.me.mp3")

# Scenes where the shared music should play
var scenes_with_shared_music = ["LoginNew", "MainMenu", "Chapters_enw"]

func _ready():
	get_tree().connect("current_scene_changed", Callable(self, "_on_scene_changed"))

func _on_scene_changed(scene):
	if not scene:
		return

	var scene_name = scene.name
	
	# Check if the scene is in the list of scenes that should share the music
	if scene_name in scenes_with_shared_music:
		if music.stream != shared_music:
			music.stream = shared_music
			music.play()  # Continue playing the shared music
	else:
		music.stop()  # Stop the music for other scenes
