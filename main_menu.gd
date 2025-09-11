extends Control

@onready var start_btn = $Start_BTN
@onready var info_btn = $Info_BTN
@onready var question_btn = $Question_BTN
@onready var crown_btn = $Crown_BTN

func _ready() -> void:
	start_btn.modulate = Color(1, 1, 1, 0)
	info_btn.modulate = Color(1, 1, 1, 0)
	question_btn.modulate = Color(1, 1, 1, 0)
	crown_btn.modulate = Color(1, 1, 1, 0)
	
func _on_info_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/info.tscn")


func _on_crown_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/hallway.tscn")


func _on_question_btn_pressed() -> void:
	pass


func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/classroom.tscn")
