extends Control

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Change back to the hallway scene
		get_tree().change_scene_to_file("res://Scenes/hallway.tscn")
