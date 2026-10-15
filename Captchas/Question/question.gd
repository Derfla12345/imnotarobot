extends Control


# ****************************************************************************************************
# default captcha methods
var screen: Node2D

func set_screen(new_screen: Node2D):
	screen = new_screen

func advance_and_close_self():
	if (screen and screen.has_method("advance_and_close_captcha")):
		screen.advance_and_close_captcha()
	else:
		print("error in not_a_robot, screen not found")
	close_self()

func close_self():
	queue_free()

# ****************************************************************************************************
# specific captcha items
@export var text_label: RichTextLabel
@export var input_field: LineEdit

var answer = ""

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("enter")):
		verify()

func set_question(new_question: String):
	text_label.set_text(new_question)

func set_answer(new_answer: String):
	answer = new_answer

func verify():
	var submission = input_field.get_text().to_lower()
	if (submission == answer):
		advance_and_close_self()


func _on_submit_button_pressed() -> void:
	verify()
