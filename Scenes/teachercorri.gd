extends Node2D

@export var dialogue_label: NodePath

@onready var _label: Label = null

func _ready() -> void:
	if dialogue_label != NodePath():
		_label = get_node(dialogue_label) as Label
		start_dialogue()


func start_dialogue() -> void:
	_show_text("Teacher: First put a wet napkin and then come back to me")
	await get_tree().create_timer(10.0).timeout
	_show_text("Teacher: We need to get down. Choose between the stairs and the lift.")
	

func _show_text(txt: String) -> void:
	if _label:
		_label.text = txt
		_label.visible = true
