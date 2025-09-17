extends Control

@onready var dialogue_box: Control = $DialogueBox
@onready var dialogue_label: Label = $DialogueBox/Label

func _ready():
	$Blocks/SmokeParticle.visible = false
	$Blocks/SmokeParticle2.visible = false
	dialogue_box.visible = false	
	await get_tree().create_timer(10).timeout
	dialogue_box.visible = true	
	await get_tree().create_timer(4.0).timeout
	$Blocks/SmokeParticle.visible = true
	$Blocks/SmokeParticle2.visible = true
	await get_tree().create_timer(3.0).timeout
	dialogue_box.visible = false	
	
	
	

func _on_area_2d_22_body_entered(body: Node2D) -> void:
	# Check if the body that entered the Area2D is the player
	if body.is_in_group("player"):
		# Change to the hallway scene
		get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")
