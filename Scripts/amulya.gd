extends CharacterBody2D

const SPEED = 100.0
const IDLE_TIME = 0.0  # seconds before switching to idle

var in_smoke: bool = false
var crawling: bool = false
@export var waypoints_node: NodePath    # assign in Classroom.tscn
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# --- Input mode ---
var input_vector := Vector2.ZERO
var idle_timer := 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var smoke_label: Label = $SmokeLabel  # direct reference

func _ready():
	await get_tree().process_frame
var cutscene_mode := false   # if true → follow waypoints, not input
var last_direction: String = "down"  # keep track of last facing direction

# --- Waypoint movement ---
var waypoints: Array[Vector2] = []
var current_point: int = 0
var moving: bool = false
var reached_endpoint: bool = false  # track if final waypoint reached

signal finished_path   # ✅ notify when done following waypoints

func _ready() -> void:
	await get_tree().process_frame
	var controller = get_tree().get_first_node_in_group("mobile_controls")
	if controller:
		controller.connect("direction_changed", Callable(self, "_on_direction_changed"))
		print("Connected to controller:", controller.name)
		controller.connect("l_pressed", Callable(self, "_on_l_pressed"))
		controller.connect("r_pressed", Callable(self, "_on_r_pressed"))
	else:
		print("No controller found")

	if waypoints_node != NodePath():
		var wp_node: Node2D = get_node(waypoints_node)
		for child in wp_node.get_children():
			if child is Marker2D:
				waypoints.append(child.global_position)


# --- Cutscene control ---
func start_cutscene() -> void:
	cutscene_mode = true
	moving = true
	current_point = 0
	reached_endpoint = false

func end_cutscene() -> void:
	cutscene_mode = false
	moving = false
	velocity = Vector2.ZERO
	idle_timer = 0.0
	_update_animation()  # show idle facing last direction


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

func _on_l_pressed() -> void:
	print("L button pressed")

func _on_r_pressed() -> void:
	print("R button pressed")

func _on_direction_changed(new_vector: Vector2) -> void:
	if cutscene_mode: return
	input_vector = new_vector
	idle_timer = 0.0
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

	if cutscene_mode:
		_cutscene_movement(delta)
	else:
		_player_movement(delta)


# --- Player controlled movement ---
func _player_movement(delta: float) -> void:
	if input_vector != Vector2.ZERO:
		velocity = input_vector.normalized() * SPEED
		idle_timer = 0.0
		reached_endpoint = false
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

# --- Cutscene (waypoint) movement ---
func _cutscene_movement(delta: float) -> void:
	if moving and current_point < waypoints.size():
		var target: Vector2 = waypoints[current_point]
		var delta_vec: Vector2 = target - global_position
		var direction: Vector2 = delta_vec.normalized()

		velocity = direction * SPEED
		move_and_slide()

		# Directional animation
		if abs(direction.x) > abs(direction.y):
			last_direction = "right" if direction.x > 0 else "left"
		else:
			last_direction = "down" if direction.y > 0 else "up"

		animated_sprite.animation = last_direction
		animated_sprite.play()
		return
	
	if input_vector == Vector2.ZERO:
		animated_sprite.stop()
		return
	
	if abs(input_vector.x) > abs(input_vector.y):
		if input_vector.x > 0:
			animated_sprite.animation = "right"

		# Check if waypoint reached
		if global_position.distance_to(target) < 5.0:
			current_point += 1
			if current_point >= waypoints.size():
				reached_endpoint = true
				_stop_cutscene_idle()
				emit_signal("finished_path")
	else:
		_stop_cutscene_idle()


# --- Animation logic ---
func _update_animation() -> void:
	var anim: String = "Idle"

	if input_vector != Vector2.ZERO:
		# Walking animation
		if abs(input_vector.x) > abs(input_vector.y):
			anim = "right" if input_vector.x > 0 else "left"
		else:
			anim = "down" if input_vector.y > 0 else "up"
		last_direction = anim
	else:
		if input_vector.y > 0:
			animated_sprite.animation = "down"
		else:
			animated_sprite.animation = "up"
	
		# No input → idle facing last direction
		anim = "Idle"

	# Apply animation if it changed
	if animated_sprite.animation != anim:
		animated_sprite.animation = anim
		animated_sprite.play()


func _stop_cutscene_idle() -> void:
	velocity = Vector2.ZERO
	move_and_slide()
	reached_endpoint = true
	animated_sprite.animation = "Idle"
	animated_sprite.play()
	moving = false


func start_moving() -> void:
	cutscene_mode = true
	moving = true
	current_point = 0
	reached_endpoint = false
