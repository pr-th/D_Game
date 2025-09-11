extends Control

func _ready() -> void:
	# Automatically connect signals for all smoke areas
	for smoke_area in get_tree().get_nodes_in_group("smoke"):
		smoke_area.body_entered.connect(_on_smoke_body_entered)
		smoke_area.body_exited.connect(_on_smoke_body_exited)

func _on_smoke_body_entered(body: Node) -> void:
	if body.is_in_group("player"):  # Amulya must be in "player" group
		body.in_smoke = true
		print("Amulya entered smoke → crawling enabled")

func _on_smoke_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		body.in_smoke = false
		body.crawling = false
		print("Amulya exited smoke → walking enabled")


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
