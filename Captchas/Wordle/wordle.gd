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
@onready var answer_template = preload("res://Captchas/Wordle/answer_template.tscn")
@export var grid_container: GridContainer
var answer = ""
var wordle_size = 5
var correct_array = [0, 0, 0, 0, 0]
var guesses = []
var max_guess_display_rows = 5

func set_wordle_size(new_wordle_size: int):
	wordle_size = new_wordle_size
	correct_array = []
	for i in range(wordle_size):
		correct_array.push_back(0)
	input_field.set_max_length(wordle_size)
	grid_container.set_columns(wordle_size)
	answer = generate_answer()

func generate_answer() -> String:
	if (wordle_size == 5):
		return "horse"
	else:
		return "horsies"

func _on_submit_button_pressed() -> void:
	print(answer)
	var submission = input_field.get_text().to_lower()
	if (submit_button):
		if submission.length() == wordle_size:
			# verify answer
			if (submission == answer):
				print("good job")
				advance_and_close_self()
			
			# detect correct and partially correct letters 
			for i in range(submission.length()):
				correct_array[i] = 0
				if (submission[i] == answer[i]):
					correct_array[i] = 1
				else:
					for j in range(wordle_size):
						if submission[i] == answer[j]:
							correct_array[i] = 2
			
			# display correct/incorrect/partially correct letters
			var new_letters = []
			for i in range(wordle_size):
				var new_letter_display = answer_template.instantiate()
				grid_container.add_child(new_letter_display)
				new_letters.push_back(new_letter_display)
				new_letter_display.set_texture(correct_array[i])
				new_letter_display.set_label(submission[i])
			guesses.push_back(new_letters)
			
			# pop off top guess if there are too many guesses
			if guesses.size() >= max_guess_display_rows:
				for i in range(wordle_size):
					guesses.front().front().remove()
					guesses.front().pop_front()
				guesses.pop_front()
		else:
			print("submission must be ", wordle_size, " characters")
		print(correct_array)

# still need logic for displaying the correct array and communicating with progression
# also need a way to communicate the 5 character limit to the player
