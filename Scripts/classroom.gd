extends Control

@onready var dialogue_box: Panel = $DialogueBox
@onready var dialogue_label: Label = $DialogueBox/Label

func _ready():
#	$Blocks/SmokeParticle.visible = false
#	$Blocks/SmokeParticle2.visible = false
	dialogue_box.visible = false
	await _show_delayed_dialogue("Would you like me to raise one of your Pokémon?", 4.0, 1.0)
	await get_tree().create_timer(12.0).timeout

#	$Blocks/SmokeParticle.visible = true
#	$Blocks/SmokeParticle2.visible = true
func _show_delayed_dialogue(text: String, delay: float, duration: float) -> void:	
	await get_tree().create_timer(delay).timeout
	dialogue_label.text = text
	dialogue_box.show()
	await get_tree().create_timer(duration).timeout
	dialogue_box.hide()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	# Check if the body that entered the Area2D is the player
	if body.is_in_group("player"):
		# Change to the hallway scene
		get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")
