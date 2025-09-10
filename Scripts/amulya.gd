extends CharacterBody2D

const SPEED = 300.0
var input_vector := Vector2.ZERO

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

func _physics_process(_delta: float) -> void:
	if input_vector != Vector2.ZERO:
		velocity = input_vector.normalized() * SPEED
	else:
		velocity = Vector2.ZERO
	move_and_slide()
