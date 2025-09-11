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
			_camera.current = true  # Ensure camera stays fixed

	# Get nodes
	for s in students:
		_students.append(get_node(s) as Node2D)

	if teacher != NodePath():
		_teacher = get_node(teacher) as Node2D
	if amulya != NodePath():
		_amulya = get_node(amulya) as Node2D
	if dialogue_label != NodePath():
		_label = get_node(dialogue_label) as Label
	if fire_node != NodePath():
		_fire = get_node(fire_node) as Node2D
		_fire.visible = false

	start_cutscene()

# --- Main cutscene ---
func start_cutscene() -> void:
	if _amulya and _amulya.has_method("start_cutscene"):
		_amulya.start_cutscene()

	print("Cutscene started")

	await _students_enter()
	await _teacher_enters()
	await _amulya_enters()
	await _run_dialogue()
	await _trigger_fire()

	if _amulya and _amulya.has_method("end_cutscene"):
		_amulya.end_cutscene()

	print("Cutscene ended")

# --- Movement helpers ---
func _students_enter() -> void:
	print("Students entering...")
	var last_student: Node2D = null
	if _students.size() > 0:
		last_student = _students[_students.size() - 1]

	for s in _students:
		if s.has_method("start_moving"):
			s.start_moving()

	if last_student != null:
		await last_student.finished_path

	print("All students entered")

func _teacher_enters() -> void:
	if _teacher and _teacher.has_method("start_moving"):
		print("Teacher entering...")
		_teacher.start_moving()
		await _teacher.finished_path
		print("Teacher entered")

func _amulya_enters() -> void:
	if _amulya and _amulya.has_method("start_moving"):
		print("Amulya entering...")
		_amulya.start_moving()
		await _amulya.finished_path
		print("Amulya entered")

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
	await get_tree().create_timer(12.0).timeout
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
