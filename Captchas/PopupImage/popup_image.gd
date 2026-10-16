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
@export var image: TextureRect

func _on_ok_button_pressed() -> void:
	advance_and_close_self()

func set_image(new_image: Texture2D):
	image.set_texture(new_image)
