extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_texture_button_pressed() -> void:
	self.get_tree().current_scene = global.last_scene
	
		
		
		
