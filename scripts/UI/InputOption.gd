class_name InputOption
extends Control

@export var displayText : RichTextLabel
@export var inputField : LineEdit

func set_display_text(text : String):
	displayText.text = text

func get_input_field() -> String:
	if inputField != null:
		return inputField.text
	else:
		return ("EMPTY")
