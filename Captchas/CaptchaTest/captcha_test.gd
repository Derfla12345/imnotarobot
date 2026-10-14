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
#@onready var scratchoff = preload("res://Captchas/Scratchoff/scratchoff.tscn")

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
	#var scratchoff_instance = scratchoff.instantiate()
	#get_tree().root.add_child(scratchoff_instance)
	#
	#return scratchoff_instance

# ****************************************************************************************************
# computer 2

func start_hello_world():
	return screen.start_captcha(hello_world)
