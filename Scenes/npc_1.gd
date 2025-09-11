extends CharacterBody2D

const SPEED: float = 100.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var waypoints_node: Node2D = $Waypoints

var waypoints: Array[Vector2] = []
var current_point: int = 0
var moving: bool = true

func _ready() -> void:
	# Collect all Marker2D nodes inside "Waypoints"
	for child in waypoints_node.get_children():
		if child is Marker2D:
			waypoints.append(child.global_position)

func _physics_process(delta: float) -> void:
	if moving and current_point < waypoints.size():
		var target: Vector2 = waypoints[current_point]
		var direction: Vector2 = (target - global_position).normalized()
		velocity = direction * SPEED
		move_and_slide()

		# Animation logic (fixed ternary)
		if abs(direction.x) > abs(direction.y):
			animated_sprite.animation = "walk_e" if direction.x > 0 else "walk_w"
		else:
			animated_sprite.animation = "walk_s" if direction.y > 0 else "walk_n"
		animated_sprite.play()

		# Check if waypoint reached
		if global_position.distance_to(target) < 5.0:
			current_point += 1
	else:
		# Stop and go idle
		velocity = Vector2.ZERO
		move_and_slide()
		animated_sprite.animation = "Idle"
		animated_sprite.play()
		moving = false
