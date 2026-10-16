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
@onready var sfx_select = $SFXSelect
@onready var sfx_type = $SFXType
@onready var sfx_wrong = $SFXWrong
@onready var seven_letter_image_path = preload("res://Captchas/Wordle/wordle7.png")

@export var longer_notice: RichTextLabel
@export var grid_container: GridContainer
@export var display_image: TextureRect

var answer = ""
var wordle_size = 5
var correct_array = [0, 0, 0, 0, 0]
var guesses = []
var max_guess_display_rows = 5

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("enter")):
		verify()

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
		display_image.set_texture(seven_letter_image_path)
		return "horsies"

func verify() -> void:
	print(answer)
	longer_notice.visible = false
	
	var submission = input_field.get_text().to_lower()
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
			sfx_wrong.play()
		guesses.push_back(new_letters)
		
		# pop off top guess if there are too many guesses
		if guesses.size() >= max_guess_display_rows:
			for i in range(wordle_size):
				guesses.front().front().remove()
				guesses.front().pop_front()
			guesses.pop_front()
	else: # if there weren't enough letters input
		longer_notice.visible = true
		print("submission must be ", wordle_size, " characters")
		sfx_wrong.play()
	input_field.set_text("")
	focus_input_box()
	print(correct_array)

func focus_input_box():
	await get_tree().process_frame
	submit_button.call_deferred("grab_focus")
	await get_tree().process_frame
	input_field.call_deferred("grab_focus")

func _on_input_field_text_changed(new_text: String) -> void:
	sfx_type.play()

func _on_submit_button_pressed() -> void:
	sfx_select.play()
	verify()
