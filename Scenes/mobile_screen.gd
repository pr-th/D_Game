extends Control

signal direction_changed(new_vector: Vector2)

var pressed_directions := {
	"up": false,
	"down": false,
	"left": false,
	"right": false
}

func _update_direction():
	var dir = Vector2.ZERO
	
	# vertical
	if pressed_directions["up"]:
		dir.y -= 1
	if pressed_directions["down"]:
		dir.y += 1
	
	# horizontal
	if pressed_directions["left"]:
		dir.x -= 1
	if pressed_directions["right"]:
		dir.x += 1
	
	# normalize so diagonals aren’t faster
	if dir != Vector2.ZERO:
		dir = dir.normalized()
	print(pressed_directions)
	emit_signal("direction_changed", dir)

func _ready():
	print("Mobile controller ready")

# --- Button handlers using button_down / button_up ---
func _on_up_button_down():
	pressed_directions["up"] = true
	_update_direction()
func _on_up_button_up():
	pressed_directions["up"] = false
	_update_direction()

func _on_down_button_down():
	pressed_directions["down"] = true
	_update_direction()
func _on_down_button_up():
	pressed_directions["down"] = false
	_update_direction()

func _on_left_button_down():
	pressed_directions["left"] = true
	_update_direction()
func _on_left_button_up():
	pressed_directions["left"] = false
	_update_direction()

func _on_right_button_down():
	pressed_directions["right"] = true
	_update_direction()
func _on_right_button_up():
	pressed_directions["right"] = false
	_update_direction()
