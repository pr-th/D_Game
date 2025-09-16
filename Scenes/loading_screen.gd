extends Control

@onready var instruction_label: RichTextLabel = $Label

var instructions: Array = [
	"Stay calm and do not panic.",
	"Alert others in the area about the fire.",
	"Use the nearest exit to evacuate safely.",
	"Do not use elevators; use stairs.",
	"Follow instructions at the emergency assembly point.\nMake sure to stay together.",
	"If smoke is present, crawl low to the ground.",
	"Cover your nose and mouth with a wet cloth or scarf,\nand wet your hair if possible."
]

var current_index: int = 0
var delay_between: float = 1  # seconds between instructions

func _ready() -> void:
	instruction_label.clear()
	# Add title
	instruction_label.push_color(Color.ORANGE)
	instruction_label.add_text("Instructions to Follow in Case of Fire\n\n")
	instruction_label.pop()
	
	show_next_instruction()
	

func show_next_instruction() -> void:
	if current_index < instructions.size():
		# Add numbered instruction in orange
		instruction_label.push_color(Color.ORANGE)
		instruction_label.add_text(str(current_index + 1) + ". ")
		instruction_label.pop()
		
		# Add instruction text
		var instr = instructions[current_index]
		instr = instr.replace("\n", "\n\n")  # extra spacing for multi-line
		instruction_label.add_text(instr + "\n\n")
		
		current_index += 1
		
		# Wait before showing the next instruction
		var timer = get_tree().create_timer(delay_between)
		timer.timeout.connect(show_next_instruction)
	else:
		get_tree().change_scene_to_file("res://Scenes/hallway.tscn")
