extends Control

@onready var win_audio: AudioStreamPlayer2D = $WinAudio   # your audio node
@onready var home_sound: AudioStreamPlayer2D = $HomeAudio 
func _ready() -> void:
	# Play win audio once when scene appears
	if win_audio and not win_audio.playing:
		win_audio.play()

func _process(delta: float) -> void:
	pass

func _on_retry_pressed() -> void:
	if home_sound:
		home_sound.play()
	await get_tree().create_timer(0.57).timeout 
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
