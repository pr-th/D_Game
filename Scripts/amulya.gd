extends CharacterBody2D

const SPEED = 300.0
var input_vector := Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity = input_vector * SPEED
	move_and_slide()


# --- Up Button ---
func _on_up_button_down() -> void:
	input_vector.y = -1

func _on_up_button_up() -> void:
	if input_vector.y == -1:
		input_vector.y = 0


# --- Down Button ---
func _on_down_button_down() -> void:
	input_vector.y = 1

func _on_down_button_up() -> void:
	if input_vector.y == 1:
		input_vector.y = 0


# --- Left Button ---
func _on_left_button_down() -> void:
	input_vector.x = -1

func _on_left_button_up() -> void:
	if input_vector.x == -1:
		input_vector.x = 0


# --- Right Button ---
func _on_right_button_down() -> void:
	input_vector.x = 1

func _on_right_button_up() -> void:
	if input_vector.x == 1:
		input_vector.x = 0
