extends Control

func _ready() -> void:
	# Add any initial setup code for the hallway scene here
	pass

func _process(delta: float) -> void:
	# Add any per-frame logic for the hallway scene here
	pass

func _on_area_2d_22_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Change to the classroom scene
		get_tree().change_scene_to_file("res://Scenes/e_classroom.tscn")

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Change to the bathroom scene
		get_tree().change_scene_to_file("res://Scenes/bathroom.tscn")


func _on_area_2d_23_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Change to the empty_bathroom scene
		get_tree().change_scene_to_file("res://Scenes/empty_classroom.tscn")


func _on_area_2_dstaircase_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Change to the staircase scene
		get_tree().change_scene_to_file("res://Scripts/staircase.tscn")


func _on_area_2_dlift_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Change to the lose scene
		global.lose_message = "The lift is unsafe during a fire. You couldn't escape."
		get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")
