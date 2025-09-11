extends CharacterBody2D

const SPEED = 300.0
const CRAWL_SPEED := 100.0
const IDLE_TIME = 3.0  # seconds before switching to idle

var in_smoke: bool = false
var crawling: bool = false
var input_vector := Vector2.ZERO
var idle_timer := 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var smoke_label: Label = $SmokeLabel  # direct reference

func _ready():
	await get_tree().process_frame
	var controller = get_tree().get_first_node_in_group("mobile_controls")
	if controller:
		controller.connect("direction_changed", Callable(self, "_on_direction_changed"))
		print("Connected to controller:", controller.name)
	else:
		push_error("Controller not found!")

	# Hide label initially and set font color black
	smoke_label.visible = false
	smoke_label.add_theme_color_override("font_color", Color.BLACK)

# 🚩 Call this when the player enters the smoke Area2D
func _on_smoke_area_entered(area: Area2D) -> void:
	in_smoke = true
	smoke_label.visible = true
	smoke_label.add_theme_color_override("font_color", Color.BLACK)

# 🚩 Call this when the player exits the smoke Area2D
func _on_smoke_area_exited(area: Area2D) -> void:
	in_smoke = false
	smoke_label.visible = false

func _on_direction_changed(new_vector: Vector2) -> void:
	input_vector = new_vector
	idle_timer = 0.0
	_update_animation()

func _physics_process(delta: float) -> void:
	if in_smoke:
		smoke_label.visible=true
		# --- Crawling mode ---
		if input_vector.x < 0:
			crawling = true
			velocity = Vector2.LEFT * CRAWL_SPEED
			animated_sprite.animation = "sit_l"
			animated_sprite.play()
		elif input_vector.x > 0:
			crawling = true
			velocity = Vector2.RIGHT * CRAWL_SPEED
			animated_sprite.animation = "sit_r"
			animated_sprite.play()
		else:
			crawling = false
			velocity = Vector2.ZERO
	else:
		smoke_label.visible=false
		# --- Normal walking mode ---
		if input_vector != Vector2.ZERO:
			velocity = input_vector.normalized() * SPEED
			idle_timer = 0.0
		else:
			velocity = Vector2.ZERO
			idle_timer += delta

	move_and_slide()
	_update_animation()

func _update_animation() -> void:
	if crawling:
		return
	
	if idle_timer >= IDLE_TIME:
		animated_sprite.animation = "Idle"
		animated_sprite.play()
		return
	
	if input_vector == Vector2.ZERO:
		animated_sprite.stop()
		return
	
	if abs(input_vector.x) > abs(input_vector.y):
		if input_vector.x > 0:
			animated_sprite.animation = "right"
		else:
			animated_sprite.animation = "left"
	else:
		if input_vector.y > 0:
			animated_sprite.animation = "down"
		else:
			animated_sprite.animation = "up"
	
	animated_sprite.play()
