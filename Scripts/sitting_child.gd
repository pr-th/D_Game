extends CharacterBody2D

const SPEED = 300.0
var running_to_exit = false
var exit_target_position = Vector2(1740, 150) # **Change this to your actual exit coordinates**

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	# Create and start a timer to trigger the escape
	var escape_timer = get_tree().create_timer(6.0)
	escape_timer.timeout.connect(Callable(self, "_on_escape_timer_timeout"))

func _on_escape_timer_timeout():
	running_to_exit = true
	# Optional: Remove the timer after it's been used
	var timer = get_tree().get_first_node_in_group("escape_timer")
	if timer:
		timer.queue_free()

func _physics_process(delta: float) -> void:
	if running_to_exit:
		# Calculate the direction to the exit
		var direction = (exit_target_position - global_position).normalized()
		velocity = direction * SPEED
		_update_animation(direction)
		
		# Check if the NPC is close enough to the exit to stop
		if global_position.distance_to(exit_target_position) < 10:
			running_to_exit = false
			velocity = Vector2.ZERO
			# You might want to hide the NPC or switch to an idle animation here
			_update_animation()
	
	move_and_slide()

func _update_animation(direction: Vector2 = Vector2.ZERO) -> void:
	if running_to_exit:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				animated_sprite.animation = "right"
			else:
				animated_sprite.animation = "left"
		else:
			if direction.y > 0:
				animated_sprite.animation = "down"
			else:
				animated_sprite.animation = "up"
		animated_sprite.play()
	else:
		# Set the initial animation, assuming "Idle" is the sitting animation
		animated_sprite.animation = "Idle"
		animated_sprite.play()
