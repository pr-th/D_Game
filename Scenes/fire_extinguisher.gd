extends Control
var pressed_dict = {
	"handle": false,
	"pin": false
}
func _on_handle_pressed() -> void:
	print(pressed_dict)
	if pressed_dict["pin"] and not pressed_dict["handle"]:
		$handle.rotation_degrees += 20
		pressed_dict["handle"] = true
		await get_tree().create_timer(0.5).timeout 
		$handle.rotation_degrees -= 20
	if pressed_dict["pin"] and pressed_dict["handle"]:
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://Scenes/staircase_wf.tscn")


func _on_pin_pressed() -> void:
	print(pressed_dict)
	if(pressed_dict["pin"] == false):		
		$pin.position.x -= 20
		pressed_dict["pin"] = true
		await get_tree().create_timer(0.5).timeout 
		$pin.hide()
	print(pressed_dict)
	
	
