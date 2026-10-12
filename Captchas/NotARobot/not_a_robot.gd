extends Control


var screen: Node2D

func set_screen(new_screen: Node2D):
	screen = new_screen

func _on_another_way_button_pressed() -> void:
	advance_and_close_self()

func advance_and_close_self():
	if (screen and screen.has_method("advance_and_close_captcha")):
		screen.advance_and_close_captcha()
	close_self()

func close_self():
	queue_free()
