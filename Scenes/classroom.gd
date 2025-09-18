extends Control

@onready var dialogue_box: Control = $DialogueBox
@onready var dialogue_label: Label = $DialogueBox/Label
@onready var theme_audio: AudioStreamPlayer2D = $ThemeAudio   # First music
@onready var smoke_audio: AudioStreamPlayer2D = $SmokeAudio   # Second music

func _ready():
	$Blocks/SmokeParticle.visible = false
	$Blocks/SmokeParticle2.visible = false
	dialogue_box.visible = false	
	theme_audio.volume_db = 7

	# Start theme music at the beginning
	if theme_audio and not theme_audio.playing:
		theme_audio.play()

	# Timeline flow
	await get_tree().create_timer(10).timeout
	dialogue_box.visible = true	

	await get_tree().create_timer(4.0).timeout
	$Blocks/SmokeParticle.visible = true
	$Blocks/SmokeParticle2.visible = true

	# Switch audio when smoke appears
	if theme_audio.playing:
		theme_audio.stop()
	if smoke_audio and not smoke_audio.playing:
		smoke_audio.play()

	await get_tree().create_timer(3.0).timeout
	dialogue_box.visible = false	


func _on_area_2d_22_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")
