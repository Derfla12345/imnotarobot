extends Node2D


@export var screen: Control #$SubViewportContainer/SubViewport/CRTView
@export var screen_camera: Camera2D
@export var computer_background: TextureRect
@export var computer_wallpaper: TextureRect
@export var fullscreen_crt: CanvasLayer
var computer_background_paths = [
	preload("res://Captchas/CaptchaTest/ComputerBackgrounds/Room1Computer.png"), 
	preload("res://Captchas/CaptchaTest/ComputerBackgrounds/Room2Computer.png"), 
	preload("res://Captchas/CaptchaTest/ComputerBackgrounds/Room3Computer.png")]
var computer_wallpaper_paths = [
	preload("res://Captchas/CaptchaTest/ComputerBackgrounds/wallpaperroom1.png"),
	preload("res://Captchas/CaptchaTest/ComputerBackgrounds/wallpaperroom2.png"),
	preload("res://Captchas/CaptchaTest/ComputerBackgrounds/wallpaperroom3.png")
]
var checkbox_image_paths = [
	preload("res://Captchas/Scratchoff/ph_scratchoff.png"),
	preload("res://Captchas/SelectAllSquares/church.jpg"),
	preload("res://Captchas/SelectAllSquares/bird.png"),
	preload("res://Captchas/SelectAllSquares/pylon.png"),
	preload("res://Captchas/Scratchoff/16_images.png")
]
var popup_image_paths = [
	preload("res://Captchas/PopupImage/Images/wave.png"),
	preload("res://Captchas/PopupImage/Images/please_puzzle.png"),
	preload("res://Captchas/PopupImage/Images/wave_evil.png"),
	preload("res://Captchas/PopupImage/Images/you_door.png"),
	preload("res://Captchas/PopupImage/Images/eyes.png"),
	preload("res://Captchas/PopupImage/Images/do_u_hate_me.png")
]
@onready var cursor = preload("res://Entities/Cursors/cursor.tscn").instantiate()
@onready var not_a_robot = preload("res://Captchas/NotARobot/not_a_robot.tscn")
@onready var wordle = preload("res://Captchas/Wordle/wordle.tscn")
@onready var hello_world = preload("res://Captchas/HelloWorld/hello_world.tscn")
@onready var scratchoff = preload("res://Captchas/Scratchoff/scratchoff.tscn")
@onready var show_password = preload("res://Captchas/ShowPassword/show_password.tscn")
@onready var question = preload("res://Captchas/Question/question.tscn")
@onready var popup_text = preload("res://Captchas/PopupText/popup_text.tscn")
@onready var popup_image = preload("res://Captchas/PopupImage/popup_image.tscn")
@onready var select_all_squares = preload("res://Captchas/SelectAllSquares/select_all_squares.tscn")
@onready var not_a_robot_glitch = preload("res://Captchas/NotARobotGlitch/not_a_robot_glitch.tscn")
@onready var not_a_robot_final = preload("res://Captchas/NotARobotFinal/not_a_robot_final.tscn")
@onready var boring_captcha = preload("res://Captchas/BoringCaptcha/boring_captcha.tscn")

@onready var sfx_success = $SFXSuccess
@onready var sfx_select = $SFXSelect
@onready var sfx_metagame_success = $SFXSuccess2
@onready var sfx_notification = $SFXNotification

var player: CharacterBody2D
var computer_off: bool = false
var progress: int = 0
var computer_index: int = 0
var current_captcha: Control
var previous_captcha: Control
var offset = Vector2(0, 0)
var metagame: bool = false
var notification: bool = false

var checkbox_scale_offset = Vector2(10, 10)
var checkbox_position_offset = Vector2(-550, -600)

func _ready():
	add_child.call_deferred(cursor)
	screen_camera.make_current()

func _on_power_button_pressed() -> void:
	turn_off()

func turn_off() -> void:
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
	if (Input.is_action_just_pressed("esc")):
		turn_off()

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
	computer_wallpaper.set_texture(computer_wallpaper_paths[computer_index])
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
					current_captcha = start_show_password("kingsecret")
				4:
					# eyes
					current_captcha = start_popup_image(popup_image_paths[4])
				5:
					# unsolveable pylon display
					current_captcha = start_scratchoff([], checkbox_image_paths[3], "")
				6:
					#start of metagame
					current_captcha = start_question("Did you know? If you put a wooden spoon on your pot while it's boiling, the pot spoon water will the spill water pot, the boiling pot water steam spoon wood.", "")
				7:
					current_captcha = start_scratchoff([[0, 0], [0, 3], [1, 3], [2, 0], [2, 2], [2, 3], [3, 0], [3, 2]], checkbox_image_paths[4], "a small object or gadget that can fit in your pocket")
				8:
					current_captcha = start_show_password("do... u...ocked")
					player.find_door(1).set_locked(false)
				9:
					current_captcha = start_not_a_robot_glitch()
				10:
					current_captcha = start_not_a_robot_final()
					player.find_door(1).set_locked(false)
					player.play_end_door_open()
				_:
					print("error: progress[", computer_index, "] does not match available values")
		1:
			match progress:
				0:
					current_captcha = start_not_a_robot()
				1:
					current_captcha = start_wordle(7)
				2:
					# wave
					current_captcha = start_popup_image(popup_image_paths[0])
				3:
					# basilica
					
					# first arg is a 2D array of integer coordinates
					# second arg is the image we're selecting squares on
					# third arg is custom text following "Select all squares that include"
					current_captcha = start_select_all_squares([[1, 1], [1, 2], [2, 0], [2, 1], [2, 2]], checkbox_image_paths[1], "a place of god")
				4:
					current_captcha = start_hello_world()
				5:
					# you go door !!
					current_captcha = start_popup_image(popup_image_paths[3])
				6:
					current_captcha = start_question("\n\n\nhow many books are in the first room?", "78") # line breaks to make it appear next to textbox
					# increment computer 1 progress to show a grid for next step. while loop in case someone inputs the password early
					# get_progress(0) to access computer 1's progress, < 4 to set it to 4 (current place of the hint)
					while (player.get_progress(0) < 4):
						player.increment_progress(0) 
				7:
					# you go door !!
					current_captcha = start_popup_image(popup_image_paths[3])
				8:
					# please puzzle computer
					current_captcha = start_popup_image(popup_image_paths[1])
				9:
					# unseeable pylon puzzle
					current_captcha = start_select_all_squares([[0, 1], [1, 1], [1, 2], [2, 1], [3, 1]], checkbox_image_paths[2], "a pylon")
				10:
					current_captcha = start_popup_image(popup_image_paths[2])
				11:
					start_metagame()
				_:
					print("error: progress[", computer_index, "] does not match available values")
		2:
			match progress:
				0:
					current_captcha = start_popup_image(popup_image_paths[0])
				1:
					current_captcha = start_popup_text("finally... here")
				2:
					current_captcha = start_boring_captcha(0)
				3:
					current_captcha = start_popup_text("capt.... human... test")
				4:
					current_captcha = start_popup_text("i ...iled... but you can...")
				5:
					current_captcha = start_popup_image(popup_image_paths[4])
				6:
					current_captcha = start_boring_captcha(1)
				7:
					current_captcha = start_boring_captcha(2)
				8:
					current_captcha = start_popup_text("see.... it....")
				9:
					current_captcha = start_boring_captcha(3)
				10:
					current_captcha = start_popup_text("now... complete the test...")
				11:
					current_captcha = start_popup_text("g....bye...")
				12:
					current_captcha = start_popup_image(popup_image_paths[5])
				13:
					current_captcha = start_popup_image(popup_image_paths[0])
				14:
					start_endgame()
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
	if (notification):
		sfx_notification.play()
		notification = false
	elif (metagame):
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

# popup text
func start_popup_text(message: String):
	notification = true
	var new_popup = screen.start_captcha(popup_text)
	new_popup.set_message(message)
	return new_popup

# popup image
func start_popup_image(image: Texture2D):
	notification = true
	var new_popup = screen.start_captcha(popup_image)
	new_popup.set_image(image)
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
	while (player.get_progress(0) < 6):
		player.increment_progress(0) # set player progress to metagame
	var door1 = player.find_door(1)
	door1.set_locked(true) # need to unlock the door later in progression
	var door3 = player.find_door(3)
	door3.set_position(Vector2(8014, 553)) # moves door 3 into place
	set_progress(player.get_progress(computer_index))
	computer_off = true

# start glitched not a robot:
func start_not_a_robot_glitch():
	return screen.start_captcha(not_a_robot_glitch)

# show final screen
func start_not_a_robot_final():
	return screen.start_captcha(not_a_robot_final)

# boring captcha
func start_boring_captcha(index: int):
	var new_boring_captcha = screen.start_captcha(boring_captcha)
	new_boring_captcha.set_answer(index)
	return new_boring_captcha

# set up game to end
func start_endgame():
	# set up player for endgame
	metagame = false
	player.set_metagame_crt(false)
	player.set_endgame(true)
	player.set_position(Vector2(1423, 709))
	player.area_camera.set_position(Vector2(0, 0))
	player.increment_progress(computer_index)
	var room2_texture_open = preload("res://Areas/room2dooropen.png")
	player.room2.set_texture(room2_texture_open)
	sfx_success.play()
	while (player.get_progress(0) < 9):
		player.increment_progress(0) # set player computer 1 progress to endgame
	
	# set up door 1 to take u to room 2 (door open)
	var end_door = player.find_door(-1)
	end_door.set_open(true)
	player.find_door(1).set_locked(true)
	
	# remove door 3
	player.find_door(3).set_position(Vector2(8119, 5076))
	
	# stop music
	player.room_3_music.stop()
	
	computer_off = true
