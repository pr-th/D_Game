extends Control

@onready var scene_audio: AudioStreamPlayer2D = $SceneAudio  # reference to your audio player

func _ready() -> void:
	# Play audio as soon as the scene loads
	if scene_audio and not scene_audio.playing:
		scene_audio.play()


func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Scenes/hallway.tscn")


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Scenes/fire_extinguisher.tscn")


func _on_area_2d_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		global.lose_message="[center][color=#FF8C00]Who thought touching fire was a good idea?[/color][/center]"
		get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")
