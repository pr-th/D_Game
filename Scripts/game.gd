extends Control


func _ready():
	var root = get_tree().root

	var target_size = Vector2i(1152, 648)
	root.content_scale_size = target_size

	
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP

	# Optional scaling multiplier (1.0 = default)
	root.content_scale_factor = 1.0
