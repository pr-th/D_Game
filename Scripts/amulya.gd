extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO

	# Movement inputs (replace with your own action names if needed)
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1

	# Normalize so diagonal movement isn't faster
	input_vector = input_vector.normalized()

	velocity = input_vector * SPEED
	move_and_slide()
