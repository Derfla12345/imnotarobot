extends Node2D


@export var screen: Control #$SubViewportContainer/SubViewport/CRTView
@export var screen_camera: Camera2D
@export var computer_background: TextureRect
@export var fullscreen_crt: CanvasLayer
var computer_background_paths = [
	preload("res://Captchas/CaptchaTest/ComputerBackgrounds/Room1Computer.png"), 
	preload("res://Captchas/CaptchaTest/ComputerBackgrounds/Room2Computer.png"), 
	preload("res://Captchas/CaptchaTest/ComputerBackgrounds/Room3Computer.png")]
var checkbox_image_paths = [
	preload("res://Captchas/Scratchoff/ph_scratchoff.png"),
	preload("res://Captchas/SelectAllSquares/church.jpg"),
	preload("res://Captchas/SelectAllSquares/bird.png"),
	preload("res://Captchas/SelectAllSquares/pylon.png"),
	preload("res://Captchas/Scratchoff/16_images.png")
]
@onready var cursor = preload("res://Entities/Cursors/cursor.tscn").instantiate()
@onready var not_a_robot = preload("res://Captchas/NotARobot/not_a_robot.tscn")
@onready var wordle = preload("res://Captchas/Wordle/wordle.tscn")
@onready var hello_world = preload("res://Captchas/HelloWorld/hello_world.tscn")
@onready var scratchoff = preload("res://Captchas/Scratchoff/scratchoff.tscn")
@onready var show_password = preload("res://Captchas/ShowPassword/show_password.tscn")
@onready var question = preload("res://Captchas/Question/question.tscn")
@onready var popup_text = preload("res://Captchas/PopupText/popup_text.tscn")
@onready var select_all_squares = preload("res://Captchas/SelectAllSquares/select_all_squares.tscn")

@onready var sfx_success = $SFXSuccess
@onready var sfx_select = $SFXSelect
@onready var sfx_metagame_success = $SFXSuccess2

var player: CharacterBody2D
var computer_off: bool = false
var progress: int = 0
var computer_index: int = 0
var current_captcha: Control
var previous_captcha: Control
var offset = Vector2(0, 0)
var metagame: bool = false

var checkbox_scale_offset = Vector2(12, 12)
var checkbox_position_offset = Vector2(-650, -1000)

func _ready():
	add_child.call_deferred(cursor)
	screen_camera.make_current()

func _on_power_button_pressed() -> void:
	sfx_select.play()
	await get_tree().create_timer(0.1).timeout # waits just long enough for the select sfx to play
	computer_off = true

# will come back to this later since a check like this in _process isn't that necessary now
func _process(delta: float) -> void:
	if computer_off:
		if (player and player.has_method("set_activity_lock")):
			player.set_activity_lock(false)
		if (current_captcha and current_captcha.has_method("close_self")):
			current_captcha.close_self()
		if (metagame):
			player.set_metagame_crt(true)
		queue_free()

func set_player(new_player: CharacterBody2D):
	player = new_player

func _exit_tree() -> void:
	remove_child.call_deferred(cursor)

func set_progress(new_progress: int):
	progress = new_progress

func set_computer_index(new_computer_index: int):
	computer_index = new_computer_index

func set_metagame(new_metagame: bool):
	metagame = new_metagame
	if(metagame):
		fullscreen_crt.visible = true

# ****************************************************************************************************
# progress logic
func set_progress_state():
	previous_captcha = current_captcha
	computer_background.set_texture(computer_background_paths[computer_index])
	match computer_index:
		0:
			match progress:
				0:
					current_captcha = start_not_a_robot()
				1:
					current_captcha = start_wordle(5)
				2:
					current_captcha = start_scratchoff([[1, 1], [1, 2], [2, 1], [2, 2]], checkbox_image_paths[0], "a stop sign")
				3:
					current_captcha = start_show_password("password")
				4:
					current_captcha = start_scratchoff([], checkbox_image_paths[3], "")
				5:
					#start of metagame
					current_captcha = start_question("Did you know? If you put a wooden spoon on your pot while it's boiling, the pot spoon water will the spill water pot, the boiling pot water steam spoon wood.", "")
				6:
					current_captcha = start_scratchoff([[0, 0], [0, 3], [1, 3], [2, 0], [2, 2], [2, 3], [3, 0], [3, 2]], checkbox_image_paths[4], "a small object or gadget that can fit in your pocket")
				7:
					current_captcha = start_show_password("door unlocked")
					player.find_door(1).set_locked(false)
				_:
					print("error: progress[", computer_index, "] does not match available values")
		1:
			match progress:
				0:
					current_captcha = start_not_a_robot()
				1:
					current_captcha = start_wordle(7)
				2:
					# first arg is a 2D array of integer coordinates
					# second arg is the image we're selecting squares on
					# third arg is custom text following "Select all squares that include"
					current_captcha = start_select_all_squares([[1, 1], [1, 2], [2, 0], [2, 1], [2, 2]], checkbox_image_paths[1], "a place of god") 
				3:
					current_captcha = start_popup_text("")
				4:
					current_captcha = start_hello_world()
				5:
					current_captcha = start_question("


how many books are in the first room?", "78") # line breaks to make it appear next to textbox
					# increment computer 1 progress to show a grid for next step. while loop in case someone inputs the password early
					# get_progress(0) to access computer 1's progress, < 4 to set it to 4 (current place of the hint)
					while (player.get_progress(0) < 4):
						player.increment_progress(0) 
				6:
					current_captcha = start_scratchoff([[0, 1], [1, 1], [1, 2], [2, 1], [3, 1]], checkbox_image_paths[2], "a pylon")
				#7:
					# another popup, this one says something like "fine, i'll show you"
				7:
					start_metagame()
				_:
					print("error: progress[", computer_index, "] does not match available values")
		_:
			print("error: computer number does not match available values")
	
	if(current_captcha and current_captcha.has_method("set_screen")):
		current_captcha.set_screen(self)

func advance_and_close_captcha():
	player.increment_progress(computer_index)
	set_progress(player.get_progress(computer_index))
	set_progress_state()
	if (metagame):
		sfx_metagame_success.play()
	else:
		sfx_success.play()

# ****************************************************************************************************
# computer 1

# not a robot (first thing to appear, progress[0] == 0)
func start_not_a_robot():
	return screen.start_captcha(not_a_robot)

# wordle (progress[0] == 1)
func start_wordle(wordle_size: int):
	var new_wordle = screen.start_captcha(wordle)
	new_wordle.set_wordle_size(wordle_size)
	return new_wordle
	#var wordle_instance = wordle.instantiate()
	#get_tree().root.add_child(wordle_instance)
	#
	#return wordle_instance

# scratchoff (progress[0] == 2)
func start_scratchoff(correct_checkboxes: Array[Array], image: Texture2D, goal_text: String):
	var new_scratchoff = screen.start_captcha(scratchoff)
	new_scratchoff.set_correct_checkboxes(correct_checkboxes)
	new_scratchoff.set_image(image)
	new_scratchoff.set_goal_text(goal_text)
	new_scratchoff.set_scale(checkbox_scale_offset)
	new_scratchoff.set_position(checkbox_position_offset)
	new_scratchoff.set_cursor(cursor)
	return new_scratchoff

# show door 1's password
func start_show_password(message: String):
	var new_password = screen.start_captcha(show_password)
	new_password.set_text(message)
	return new_password

# ****************************************************************************************************
# computer 2

# hello world
func start_hello_world():
	return screen.start_captcha(hello_world)

# question about other room
func start_question(question_text: String, answer_value: String):
	var new_question = screen.start_captcha(question)
	new_question.set_question(question_text)
	new_question.set_answer(answer_value)
	
	return new_question

# popup
func start_popup_text(message: String):
	var new_popup = screen.start_captcha(popup_text)
	new_popup.set_message(message)
	return new_popup

# select all squares
func start_select_all_squares(correct_checkboxes: Array[Array], image: Texture2D, goal_text: String):
	var new_select_all_squares = screen.start_captcha(select_all_squares)
	new_select_all_squares.set_scale(checkbox_scale_offset)
	new_select_all_squares.set_position(checkbox_position_offset)
	new_select_all_squares.set_correct_checkboxes(correct_checkboxes)
	new_select_all_squares.set_image(image)
	new_select_all_squares.set_goal_text(goal_text)
	
	return new_select_all_squares

# start metagame
func start_metagame():
	metagame = true
	player.set_metagame_crt(true)
	player.set_position(Vector2(1423, 709))
	player.area_camera.set_position(Vector2(0, 0))
	player.increment_progress(computer_index)
	player.play_metagame_success()
	while (player.get_progress(0) < 5):
		player.increment_progress(0) # set player progress to metagame
	var door1 = player.find_door(1)
	door1.set_locked(true) # need to unlock the door later in progression
	var door3 = player.find_door(3)
	door3.set_position(Vector2(8014, 553)) # moves door 3 into place
	set_progress(player.get_progress(computer_index))
	computer_off = true
