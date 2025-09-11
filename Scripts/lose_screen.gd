extends Control

@onready var desc_label = $Panel/desc

func _ready():
	desc_label.text = global.lose_message if global.lose_message != "" else "You lost!"
