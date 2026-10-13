extends Node2D

@export var screen: Control #$SubViewportContainer/SubViewport/CRTView
@onready var cursor = preload("res://Entities/Cursors/cursor.tscn").instantiate()
@onready var not_a_robot = preload("res://Captchas/NotARobot/not_a_robot.tscn")
@onready var wordle = preload("res://Captchas/Wordle/wordle.tscn")
#@onready var scratchoff = preload("res://Captchas/Scratchoff/scratchoff.tscn")

var player: CharacterBody2D
var computer_off: bool = false
var progress: int = 0
var current_captcha: Control
var previous_captcha: Control

func _ready():
	add_child.call_deferred(cursor)

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

# ****************************************************************************************************
# progress logic
func set_progress_state():
	previous_captcha = current_captcha
	match progress:
		0:
			current_captcha = start_not_a_robot()
		1:
			current_captcha = start_wordle()
		#2:
			#current_captcha = start_scratchoff()
		_:
			print("error: progress does not match available values")
	
	if(current_captcha and current_captcha.has_method("set_screen")):
		current_captcha.set_screen(self)

func advance_and_close_captcha():
	player.increment_progress()
	set_progress(player.get_progress())
	set_progress_state()

# ****************************************************************************************************
# not a robot (first thing to appear, progress == 0)
func start_not_a_robot():
	return screen.start_captcha(not_a_robot)

# ****************************************************************************************************
# wordle (progress == 1)
func start_wordle():
	return screen.start_captcha(wordle)
	#var wordle_instance = wordle.instantiate()
	#get_tree().root.add_child(wordle_instance)
	#
	#return wordle_instance

# ****************************************************************************************************
# scratchoff (progress == 2)
#func start_scratchoff():
	#var scratchoff_instance = scratchoff.instantiate()
	#get_tree().root.add_child(scratchoff_instance)
	#
	#return scratchoff_instance
