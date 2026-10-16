extends Control


# ****************************************************************************************************
# default captcha methods
var screen: Node2D

func set_screen(new_screen: Node2D):
	screen = new_screen

func advance_and_close_self():
	if (screen and screen.has_method("advance_and_close_captcha")):
		screen.advance_and_close_captcha()
	close_self()

func close_self():
	queue_free()

# ****************************************************************************************************
# specific captcha items
@export var text_label: RichTextLabel

func _on_ok_button_pressed() -> void:
	advance_and_close_self()

func set_message(new_message: String):
	text_label.set_text(new_message) # this might end up being emoji so it might be a grid of images
