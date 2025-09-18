extends Control

@onready var desc_label = $Panel/desc
@onready var lose_audio: AudioStreamPlayer2D = $LoseAudio   # reference to your audio node

func _ready():
	# Set lose message
	desc_label.text = global.lose_message if global.lose_message != "" else "You lost!"
	lose_audio.volume_db = -3

	# Play once when screen appears
	if lose_audio and not lose_audio.playing:
		lose_audio.play()


func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_learn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/kahoot.tscn")
