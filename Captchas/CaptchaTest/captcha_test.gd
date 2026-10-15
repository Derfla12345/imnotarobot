extends Node2D


@export var screen: Control #$SubViewportContainer/SubViewport/CRTView
@export var screen_camera: Camera2D
@export var computer_background: TextureRect
var computer_background_paths = [
	preload("res://Captchas/CaptchaTest/ComputerBackgrounds/Room1Computer.png"), 
	preload("res://Captchas/CaptchaTest/ComputerBackgrounds/Room2Computer.png"), 
	preload("res://Captchas/CaptchaTest/ComputerBackgrounds/Room3Computer.png")]
@onready var cursor = preload("res://Entities/Cursors/cursor.tscn").instantiate()
@onready var not_a_robot = preload("res://Captchas/NotARobot/not_a_robot.tscn")
@onready var wordle = preload("res://Captchas/Wordle/wordle.tscn")
@onready var hello_world = preload("res://Captchas/HelloWorld/hello_world.tscn")
@onready var scratchoff = preload("res://Captchas/Scratchoff/scratchoff.tscn")
@onready var show_password = preload("res://Captchas/ShowPassword/show_password.tscn")
@onready var question = preload("res://Captchas/Question/question.tscn")

var player: CharacterBody2D
var computer_off: bool = false
var progress: int = 0
var computer_index: int = 0
var current_captcha: Control
var previous_captcha: Control
var offset = Vector2(0, 0)

func _ready():
	add_child.call_deferred(cursor)
	screen_camera.make_current()

func _on_power_button_pressed() -> void:
	computer_off = true

# will come back to this later since a check like this in _process isn't that necessary now
func _process(delta: float) -> void:
	if computer_off:
		if (player and player.has_method("set_activity_lock")):
			player.set_activity_lock(false)
		if (current_captcha and current_captcha.has_method("close_self")):
			current_captcha.close_self()
		queue_free()

func set_player(new_player: CharacterBody2D):
	player = new_player

func _exit_tree() -> void:
	remove_child.call_deferred(cursor)

func set_progress(new_progress: int):
	progress = new_progress

func set_computer_index(new_computer_index: int):
	computer_index = new_computer_index

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
				#2:
					#current_captcha = start_scratchoff()
				3:
					current_captcha = start_show_password()
				#4:
					# showing the answer to the captcha on computer 2
				_:
					print("error: progress[", computer_index, "] does not match available values")
		1:
			match progress:
				0:
					current_captcha = start_not_a_robot()
				1:
					current_captcha = start_wordle(7)
				2:
					current_captcha = start_hello_world()
				3:
					current_captcha = start_question("how many books are in the first room?", "78")
				#4:
					# a captcha asking you to select all squares. the squares can only be seen on computer 1
				#5:
					# some communication attempt popups should have happened before this point.
					# at this point, you'll be taken into the meta game
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
#func start_scratchoff():
	#var new_scratchoff = screen.start_captcha(scratchoff)
	#var scale_offset = Vector2(12, 12)
	#var position_offset = Vector2(-650, -1000)
	#new_scratchoff.set_scale(scale_offset)
	#new_scratchoff.set_position(position_offset)
	#return new_scratchoff

# show door 1's password
func start_show_password():
	return screen.start_captcha(show_password)

# ****************************************************************************************************
# computer 2

func start_hello_world():
	return screen.start_captcha(hello_world)

func start_question(question_text: String, answer_value: String):
	var new_question = screen.start_captcha(question)
	new_question.set_question(question_text)
	new_question.set_answer(answer_value)
	
	return new_question
