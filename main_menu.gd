extends Control

@onready var start_btn = $Start_BTN
@onready var info_btn = $Info_BTN
@onready var question_btn = $Question_BTN
@onready var crown_btn = $Crown_BTN
@onready var info_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D 
@onready var menu_music: AudioStreamPlayer2D = $MenuMusic  # background music

func _ready() -> void:
	start_btn.modulate = Color(1, 1, 1, 0)
	info_btn.modulate = Color(1, 1, 1, 0)
	question_btn.modulate = Color(1, 1, 1, 0)
	crown_btn.modulate = Color(1, 1, 1, 0)

	# Play menu music when the scene loads
	if menu_music and not menu_music.playing:
		menu_music.play()

func _on_info_btn_pressed() -> void:
	if info_sound:
		info_sound.play()
	await get_tree().create_timer(0.57).timeout
	get_tree().change_scene_to_file("res://Scenes/info.tscn")

func _on_crown_btn_pressed() -> void:
	pass

func _on_question_btn_pressed() -> void:
	pass

func _on_start_btn_pressed() -> void:
	global.scarf = false
	get_tree().change_scene_to_file("res://Scenes/classroom.tscn")
