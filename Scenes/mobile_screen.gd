extends Control

signal direction_changed(new_vector: Vector2)

func _ready():
	print("Mobile controller ready")

func _on_up_pressed():	
	emit_signal("direction_changed", Vector2.UP)

func _on_down_pressed():
	emit_signal("direction_changed", Vector2.DOWN)

func _on_left_pressed():
	emit_signal("direction_changed", Vector2.LEFT)

func _on_right_pressed():
	emit_signal("direction_changed", Vector2.RIGHT)
