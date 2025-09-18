extends Control

var pressed_dict = {
	"handle": false,
	"pin": false
}

@onready var pin_audio: AudioStreamPlayer2D = $PinAudio        # Sound when pin is pulled
@onready var handle_audio: AudioStreamPlayer2D = $ReleaseAudio  # Sound when handle is pressed

func _on_handle_pressed() -> void:
	print(pressed_dict)
	if pressed_dict["pin"] and not pressed_dict["handle"]:
		$handle.rotation_degrees += 20
		pressed_dict["handle"] = true
		await get_tree().create_timer(0.5).timeout 
		$handle.rotation_degrees -= 20

		# ✅ Play audio after handle animation completes
		if handle_audio and not handle_audio.playing:
			handle_audio.play()

	if pressed_dict["pin"] and pressed_dict["handle"]:
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://Scenes/staircase_wf.tscn")


func _on_pin_pressed() -> void:
	print(pressed_dict)
	if not pressed_dict["pin"]:		
		$pin.position.x -= 20
		pressed_dict["pin"] = true
		
		# ✅ Play audio when pin is removed
		if pin_audio and not pin_audio.playing:
			pin_audio.play()

		await get_tree().create_timer(0.5).timeout 
		$pin.hide()

	print(pressed_dict)
