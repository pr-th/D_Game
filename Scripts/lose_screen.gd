extends Control

@onready var desc_label = $Panel/desc

func _ready():
	desc_label.text = global.lose_message if global.lose_message != "" else "You lost!"


func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_learn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/kahoot.tscn")
