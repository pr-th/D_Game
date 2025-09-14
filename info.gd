extends Control
@export var json_file: String = "res://Assets/pages.json"
var pages: Array = []
var current_page: int = 0

@onready var left_page = $Left_page
@onready var right_page = $Right_page
@onready var next_button = $next_button
@onready var prev_button = $prev_button
@onready var home_button = $home_btn
@onready var page_flip_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D   # 📖 flip sound
@onready var home_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D2       # 🏠 home sound (new node)

func _ready():
	load_pages()
	update_book()
	next_button.modulate = Color(1, 1, 1, 0)  
	prev_button.modulate = Color(1, 1, 1, 0)
	home_button.modulate = Color(1,1,1,0)
	home_button.pressed.connect(_on_home)
	next_button.pressed.connect(_on_next_page)
	prev_button.pressed.connect(_on_prev_page)
	
func load_pages():
	var file = FileAccess.open(json_file, FileAccess.READ)
	if file:
		var result = JSON.parse_string(file.get_as_text())
		if typeof(result) == TYPE_ARRAY:
			pages = result
	file.close()

func update_book():
	if current_page < pages.size():
		var left = pages[current_page]
		left_page.clear()
		left_page.push_font_size(28)
		left_page.push_paragraph(HORIZONTAL_ALIGNMENT_CENTER)
		left_page.add_text(left.get("title", ""))
		left_page.pop()
		left_page.add_text("\n\n")
		left_page.push_font_size(15)
		left_page.add_text(left.get("content", ""))
	else:
		left_page.text = ""
	
	if current_page + 1 < pages.size():
		var right = pages[current_page + 1]
		right_page.clear()
		right_page.push_font_size(28)
		right_page.push_paragraph(HORIZONTAL_ALIGNMENT_CENTER)
		right_page.add_text(right.get("title", ""))
		right_page.pop()
		right_page.add_text("\n\n")
		right_page.push_font_size(15)
		right_page.add_text(right.get("content", ""))
	else:
		right_page.text = ""

func _on_next_page():
	if current_page + 2 < pages.size():
		current_page += 2
		update_book()
		if page_flip_sound:
			page_flip_sound.play()

func _on_prev_page():
	if current_page - 2 >= 0:
		current_page -= 2
		update_book()
		if page_flip_sound:
			page_flip_sound.play()

func _on_home() -> void:
	if home_sound:
		home_sound.play()
	await get_tree().create_timer(0.57).timeout   # ⏳ wait 3 seconds
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
