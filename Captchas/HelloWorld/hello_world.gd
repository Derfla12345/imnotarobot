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
@export var input_field: LineEdit
@export var submit_button: TextureButton

var incorrect_answers = ["hello", "world"]
var wrong: bool = false

func _on_submit_button_pressed() -> void:
	var submission = input_field.get_text().to_lower()
	# verify answer
	for i in incorrect_answers:
		if (submission.contains(i)):
			print("bad job") # do something on-screen to signify wrongness
			wrong = true
	if (not wrong):
		print("good job")
		advance_and_close_self()
	
	wrong = false
