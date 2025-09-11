extends Control

func _ready() -> void:
	# Add any initial setup code for the hallway scene here
	pass

func _process(delta: float) -> void:
	# Add any per-frame logic for the hallway scene here
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Change to the classroom scene
		get_tree().change_scene_to_file("res://Scenes/classroom.tscn")

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Change to the bathroom scene
		get_tree().change_scene_to_file("res://Scenes/bathroom.tscn")
