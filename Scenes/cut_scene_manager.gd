extends Node

# --- Exports ---
@export var students: Array[NodePath]
@export var teacher: NodePath
@export var amulya: NodePath
@export var dialogue_label: NodePath
@export var fire_node: NodePath
@export var main_camera: NodePath  # Stationary camera

# --- Signals ---
signal dialogue_finished

# --- Onready vars ---
@onready var _students: Array[Node2D] = []
@onready var _teacher: Node2D = null
@onready var _amulya: Node2D = null
@onready var _label: Label = null
@onready var _fire: Node2D = null
@onready var _camera: Camera2D = null  # Stationary camera

func _ready() -> void:
	# Set up stationary camera
	if main_camera != NodePath():
		_camera = get_node(main_camera) as Camera2D
		if _camera:
			_camera.current = true

	# Get student nodes
	for s in students:
		var n = get_node_or_null(s)
		if n:
			_students.append(n as Node2D)
		else:
			print("Warning: student node not found: ", s)

	# Teacher & Amulya
	if teacher != NodePath():
		_teacher = get_node_or_null(teacher) as Node2D
		if _teacher == null:
			print("Warning: teacher node not found: ", teacher)

	if amulya != NodePath():
		_amulya = get_node_or_null(amulya) as Node2D
		if _amulya == null:
			print("Warning: amulya node not found: ", amulya)
		else:
			# hide the sprite/character until we trigger her entrance
			if _amulya.has_node("AnimatedSprite2D"):
				_amulya.get_node("AnimatedSprite2D").visible = false
			elif _amulya is CanvasItem:
				_amulya.visible = false

	# Label & fire
	if dialogue_label != NodePath():
		_label = get_node_or_null(dialogue_label) as Label
	if fire_node != NodePath():
		_fire = get_node_or_null(fire_node) as Node2D
		if _fire:
			_fire.visible = false

	# start the sequence (async)
	start_cutscene()


# --- Main cutscene ---
func start_cutscene() -> void:
	print("Cutscene started")

	await _students_enter()
	await _teacher_enters()
	await _amulya_enters()
	await _run_dialogue()
	await _trigger_fire()

	# ensure Amulya ends cutscene mode if she has that method
	if _amulya and _amulya.has_method("end_cutscene"):
		_amulya.end_cutscene()

	print("Cutscene ended")


# --- Movement helpers ---
func _students_enter() -> void:
	print("Students entering...")
	if _students.size() == 0:
		print("No students to move.")
		return

	var last_student: Node2D = _students[_students.size() - 1]

	for s in _students:
		if s.has_method("start_moving"):
			s.start_moving()

	# wait for last student's finished_path signal, fallback to timer
	if last_student and last_student.has_signal("finished_path"):
		await last_student.finished_path
	else:
		print("No finished_path on last student; using fallback wait")
		await get_tree().create_timer(0.8).timeout

	print("All students entered")


func _teacher_enters() -> void:
	if _teacher and _teacher.has_method("start_moving"):
		print("Teacher entering...")
		_teacher.start_moving()
		if _teacher.has_signal("finished_path"):
			await _teacher.finished_path
		else:
			# fallback wait
			await get_tree().create_timer(0.8).timeout
		print("Teacher entered")
	else:
		print("No teacher movement configured or teacher missing")


func _amulya_enters() -> void:
	if _amulya == null:
		print("Amulya node missing; skipping Amulya entrance")
		return

	print("Amulya entering... (making visible first)")

	# Make Amulya visible BEFORE starting movement
	if _amulya.has_node("AnimatedSprite2D"):
		var sprite = _amulya.get_node("AnimatedSprite2D")
		sprite.visible = true
	elif _amulya is CanvasItem:
		_amulya.visible = true

	# Ensure any accidental transparency is reset
	if _amulya is CanvasItem:
		_amulya.modulate.a = 1.0
		if _amulya.has_node("AnimatedSprite2D"):
			_amulya.get_node("AnimatedSprite2D").modulate.a = 1.0

	# Start Amulya's movement using the method your Amulya script provides.
	# Your Amulya script has start_cutscene() (not start_moving), so call that.
	if _amulya.has_method("start_cutscene"):
		_amulya.start_cutscene()
		# wait for the finished_path signal (with fallback)
		if _amulya.has_signal("finished_path"):
			await _amulya.finished_path
		else:
			print("Amulya has no finished_path signal; waiting fallback")
			await get_tree().create_timer(1.0).timeout
		print("Amulya entered")
	elif _amulya.has_method("start_moving"):
		_amulya.start_moving()
		if _amulya.has_signal("finished_path"):
			await _amulya.finished_path
		else:
			await get_tree().create_timer(1.0).timeout
		print("Amulya entered (via start_moving)")
	else:
		print("Amulya has no movement method; skipping movement")


# --- Dialogue ---
func _run_dialogue() -> void:
	print("Dialogue starting...")
	var lines := [
		"Teacher: Welcome class, today we will begin...",
		"Teacher: Please pay attention."
	]

	for line in lines:
		print("Showing line: ", line)
		_show_text(line)
		var wait_time: float = float(line.length()) * 0.05
		if wait_time < 1.5:
			wait_time = 1.5
		await get_tree().create_timer(wait_time).timeout

	_clear_text()
	print("Dialogue finished")
	emit_signal("dialogue_finished")


# --- Fire ---
func _trigger_fire() -> void:
	print("Triggering fire now")
	if _fire:
		_fire.visible = true
	await get_tree().create_timer(1.0).timeout
	_clear_text()
	print("Fire sequence done")


# --- Helpers ---
func _show_text(txt: String) -> void:
	if _label:
		_label.text = txt
		_label.visible = true

func _clear_text() -> void:
	if _label:
		_label.text = ""
		_label.visible = false
