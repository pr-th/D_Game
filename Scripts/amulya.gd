extends CharacterBody2D

const SPEED = 300.0
const IDLE_TIME = 3.0  # seconds before switching to idle

var input_vector := Vector2.ZERO
var idle_timer := 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	await get_tree().process_frame  
	var controller = get_tree().get_first_node_in_group("mobile_controls")
	if controller:
		controller.connect("direction_changed", Callable(self, "_on_direction_changed"))
		print("Connected to controller:", controller.name)
	else:
		push_error("Controller not found!")

func _on_direction_changed(new_vector: Vector2) -> void:
	input_vector = new_vector
	idle_timer = 0.0  # reset idle timer when input is detected
	_update_animation()

func _physics_process(delta: float) -> void:
	if input_vector != Vector2.ZERO:
		velocity = input_vector.normalized() * SPEED
		idle_timer = 0.0  # reset timer while moving
	else:
		velocity = Vector2.ZERO
		idle_timer += delta
	move_and_slide()
	_update_animation()

func _update_animation() -> void:
	if idle_timer >= IDLE_TIME:
		animated_sprite.animation = "Idle"
		animated_sprite.play()
		return
	
	if input_vector == Vector2.ZERO:
		animated_sprite.stop()
		return
	
	if abs(input_vector.x) > abs(input_vector.y):
		# Horizontal movement
		if input_vector.x > 0:
			animated_sprite.animation = "right"
		else:
			animated_sprite.animation = "left"
	else:
		# Vertical movement
		if input_vector.y > 0:
			animated_sprite.animation = "down"
		else:
			animated_sprite.animation = "up"
	
	animated_sprite.play()
