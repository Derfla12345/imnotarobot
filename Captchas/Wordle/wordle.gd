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
@onready var input_field: LineEdit = $InputField
@onready var submit_button: TextureButton = $SubmitButton
var answer = generate_answer()
var correct_array = [0, 0, 0, 0, 0]

func generate_answer() -> String:
	return "horse"

func _on_submit_button_pressed() -> void:
	var submission = input_field.get_text().to_lower()
	if (submit_button):
		if submission.length() == correct_array.size():
			for i in range(submission.length()):
				if (submission[i] == answer[i]):
					correct_array[i] = 1
				else:
					for j in range(i, correct_array.size()):
						if submission[i] == answer[j]:
							correct_array[j] = 2
			if (submission == answer):
				print("good job")
				advance_and_close_self()
			else:
				print("epic fail")
		else:
			print("submission must be 5 characters")
		print(correct_array)

# still need logic for displaying the correct array and communicating with progression
# also need a way to communicate the 5 character limit to the player
