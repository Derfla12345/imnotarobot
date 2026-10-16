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
@onready var sfx_type = $TypeRandomizer
@onready var sfx_wrong = $SFXWrong

@export var longer_notice: RichTextLabel
@export var grid_container: GridContainer
@export var display_image: TextureRect

var answer = ""
var answers = ["g3hc9", "3l87z", "5d12g", "xo4nk"]
var answer_paths = [
	preload("res://Captchas/BoringCaptcha/letter_captcha_1.png"),
	preload("res://Captchas/BoringCaptcha/letter_captcha_2.png"),
	preload("res://Captchas/BoringCaptcha/letter_captcha_3.png"),
	preload("res://Captchas/BoringCaptcha/letter_captcha_4.png")
]
var wordle_size = 5
var correct_array = [0, 0, 0, 0, 0]
var guesses = []
var max_guess_display_rows = 5

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("enter")):
		verify()

func set_answer(answer_index: int):
	answer = answers[answer_index]
	display_image.set_texture(answer_paths[answer_index])

func verify() -> void:
	var submission = input_field.get_text().to_lower()
	if (submission == answer):
		print("good job")
		advance_and_close_self()
	else:
		sfx_wrong.play()
		
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
