extends Control
@onready var home_music: AudioStreamPlayer2D = $HomeAudio
var questions = [
	{
		"q": "What is the safest way to exit a smoke-filled room?",
		"options": ["Run quickly", "Crawl low under the smoke", "Stand tall and breathe deeply", "Wait for rescue in the middle of the room"],
		"answer": 1
	},
	{
		"q": "Which fire extinguisher should be used on electrical fires?",
		"options": ["Water", "Foam", "CO₂", "Wet chemical"],
		"answer": 2
	},
	{
		"q": "What should you do if your clothes catch fire?",
		"options": ["Run outside", "Jump into bed", "Stop, drop, and roll", "Wave arms for help"],
		"answer": 2
	},
	{
		"q": "Why should you never use a lift (elevator) during a fire?",
		"options": ["It is too slow", "Smoke can enter easily", "It may stop working and trap you", "The buttons can melt"],
		"answer": 2
	},
	{
		"q": "If trapped in a room during a fire, what should you do?",
		"options": ["Break a window and jump", "Seal gaps with wet cloth and signal for help", "Hide in a cupboard", "Light another fire for attention"],
		"answer": 1
	}
]

var current_question = 0
var score = 0

@onready var question_label = $question
@onready var option1 = $option1
@onready var option2 = $option2
@onready var option3 = $option3
@onready var option4 = $option4
@onready var options = [option1, option2, option3, option4]

func _ready():
	question_label.add_theme_constant_override("line_separation", 10)
	# Extra spacing between paragraphs (when you use \n)
	question_label.add_theme_constant_override("paragraph_separation", 15)
	load_question()

func load_question():
	var q = questions[current_question]
	question_label.text = q["q"]
	for i in range(4):
		options[i].text = q["options"][i]
		options[i].modulate = Color(1, 1, 1) # reset color to normal
		options[i].disabled = false

func check_answer(selected_idx: int):
	var correct = questions[current_question]["answer"]

	# Disable all buttons after one is clicked
	for b in options:
		b.disabled = true

	# Show correct/incorrect colors
	if selected_idx == correct:
		score += 1
		options[selected_idx].modulate = Color(0, 1, 0) # green
	else:
		options[selected_idx].modulate = Color(1, 0, 0) # red
		options[correct].modulate = Color(0, 1, 0) # green

	# Wait 1.5 seconds before moving to next
	await get_tree().create_timer(1.5).timeout

	current_question += 1
	if current_question < questions.size():
		load_question()
	else:
		show_final_score()

func show_final_score():
	question_label.text = "Quiz finished! Your score: %d / %d" % [score, questions.size()]
	for b in options:
		b.hide()

func _on_texture_button_pressed() -> void:
	home_music.volume_db = -5
	if home_music and not home_music.playing:
		home_music.play()
	await get_tree().create_timer(0.57).timeout
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_option_1_pressed() -> void:
	check_answer(0)

func _on_option_2_pressed() -> void:
	check_answer(1)

func _on_option_3_pressed() -> void:
	check_answer(2)

func _on_option_4_pressed() -> void:
	check_answer(3)
