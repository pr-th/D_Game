extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Change to the hallway scene
		get_tree().change_scene_to_file("res://Scenes/hallway.tscn")


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Change to the fire extinguisher scene
		get_tree().change_scene_to_file("res://Scenes/fire_extinguisher.tscn")

func _on_area_2d_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Change to the fire extinguisher scene
		global.lose_message="[center][color=#FF8C00]Who thought touching fire was a good idea?[/color][/center]"
		get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")
