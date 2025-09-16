extends Control

func _ready():
#	$Blocks/SmokeParticle.visible = false
#	$Blocks/SmokeParticle2.visible = false

	await get_tree().create_timer(12.0).timeout

#	$Blocks/SmokeParticle.visible = true
#	$Blocks/SmokeParticle2.visible = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	# Check if the body that entered the Area2D is the player
	if body.is_in_group("player"):
		# Change to the hallway scene
		get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")
