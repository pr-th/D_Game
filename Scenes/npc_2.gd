extends CharacterBody2D

const SPEED: float = 100.0

@export var waypoints_node: NodePath  # assign in the inspector (drag "Waypoints" here)
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var waypoints: Array[Vector2] = []
var current_point: int = 0
var moving: bool = true
var last_direction: String = "walk_s" # Default facing south

func _ready() -> void:
	if waypoints_node != NodePath():
		var wp_node: Node2D = get_node(waypoints_node)
		for child in wp_node.get_children():
			if child is Marker2D:
				waypoints.append(child.global_position)

func _physics_process(delta: float) -> void:
	if moving and current_point < waypoints.size():
		var target: Vector2 = waypoints[current_point]
		var delta_vec: Vector2 = target - global_position
		var direction: Vector2 = delta_vec.normalized()

		velocity = direction * SPEED
		move_and_slide()

		# --- instant block detection ---
		if get_slide_collision_count() > 0:
			_stop_with_idle()
			return

		# Animation + save last direction
		if abs(direction.x) > abs(direction.y):
			last_direction = "walk_e" if direction.x > 0 else "walk_w"
		else:
			last_direction = "walk_s" if direction.y > 0 else "walk_n"

		animated_sprite.animation = last_direction
		animated_sprite.play()

		# Check if waypoint reached
		if global_position.distance_to(target) < 5.0:
			current_point += 1
	else:
		_stop_with_idle()

func _stop_with_idle() -> void:
	velocity = Vector2.ZERO
	move_and_slide()

	match last_direction:
		"walk_e": animated_sprite.animation = "idle_e"
		"walk_w": animated_sprite.animation = "idle_w"
		"walk_s": animated_sprite.animation = "idle_s"
		"walk_n": animated_sprite.animation = "idle_n"

	animated_sprite.play()
	moving = false
