extends Control
func _ready():
	$Blocks/SmokeParticle.visible = false
	$Blocks/SmokeParticle2.visible = false

	await get_tree().create_timer(12.0).timeout

	$Blocks/SmokeParticle.visible = true
	$Blocks/SmokeParticle2.visible = true
