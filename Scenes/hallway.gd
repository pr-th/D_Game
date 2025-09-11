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
