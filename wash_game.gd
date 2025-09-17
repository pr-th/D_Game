extends Control

var attempts: int = 3
var pointer_speed: float = 300.0
var pointer_direction: int = 1

@onready var bar: TextureRect = $bar
@onready var middle_zone: TextureRect = $bar/"Green Spot"
@onready var pointer: TextureRect = $bar/pointer
@onready var attempts_label: Label = $Label


func _ready() -> void:
	_update_attempts_label()


func _process(delta: float) -> void:
	# Move pointer left and right across the bar
	pointer.position.x += pointer_speed * pointer_direction * delta

	var bar_rect: Rect2 = $bar/HitArea.get_global_rect()
	var pointer_rect: Rect2 = pointer.get_global_rect()

	# Bounce at edges
	if pointer_rect.position.x <= bar_rect.position.x:
		pointer_direction = 1
	else:
		if pointer_rect.position.x + pointer_rect.size.x >= bar_rect.position.x + bar_rect.size.x:
			pointer_direction = -1


func _input(event: InputEvent) -> void:
		# Mouse (for desktop testing)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_on_player_click()

	# Touch (for mobile)
	if event is InputEventScreenTouch and event.pressed:
		_on_player_click()



func _on_player_click() -> void:
	var p_rect: Rect2 = pointer.get_global_rect()
	var m_rect: Rect2 = middle_zone.get_global_rect()

	if p_rect.intersects(m_rect):
		_on_success()
	else:
		_on_fail()


func _on_fail() -> void:
	attempts -= 1
	_update_attempts_label()

	if attempts <= 0:
		global.lose_message="[center][color=#FF8C00]You were unable to tie the napkin on time.[/color][/center]"
		get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")


func _on_success() -> void:
	global.scarf = true
	get_tree().change_scene_to_file("res://Scenes/bathroom.tscn")


func _update_attempts_label() -> void:
	if attempts >= 0:
		attempts_label.text = "Attempts left: " + str(attempts)
	else:
		attempts_label.text = "No attempts left"
