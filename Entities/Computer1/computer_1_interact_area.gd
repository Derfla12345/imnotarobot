extends Area2D


@onready var captcha_test = preload("res://Captchas/CaptchaTest/captcha_test.tscn")
@onready var computer_index = get_parent().get_computer_index()
@onready var dialogue_box = preload("res://Dialogue/dialogue.tscn")
@onready var sfx_select = $"../SFXSelect"

@export var dialogue_cooldown: Timer
var dialogue_cooldown_active: bool = false

var current_player
var current_dialogue_box
var dialogue: bool = false
var dialogue_trees = [
	["It doesn't seem to be working."]
]
var current_dialogue_tree: int = 0
var current_dialogue_step: int = 0

func get_computer_index():
	return computer_index

func interact(player: CharacterBody2D):
	current_player = player
	if (is_metagame_computer_2(player)):
		start_metagame_computer_dialogue(player)
	else:
		var captcha_test_instance = captcha_test.instantiate()
		get_tree().root.add_child(captcha_test_instance)
		player.set_activity_lock(true)
		captcha_test_instance.set_player(player)
		captcha_test_instance.set_computer_index(computer_index)
		captcha_test_instance.set_progress(player.get_progress(computer_index))
		captcha_test_instance.set_progress_state()
		if player.get_metagame_crt():
			captcha_test_instance.set_metagame(true)
			player.set_metagame_crt(false)

# checks whether you're trying to access computer 2 during the metagame or in the endgame room 2
func is_metagame_computer_2(player: CharacterBody2D) -> bool:
	var answer: bool = false
	if (computer_index == 1 and (player.get_metagame_crt() or player.get_endgame())):
		answer = true
	
	return answer

func start_metagame_computer_dialogue(player: CharacterBody2D):
	if (not dialogue_cooldown_active):
		player.start_dialogue()
		
		var new_dialogue_box = dialogue_box.instantiate()
		get_tree().root.add_child(new_dialogue_box)
		if (computer_index == 1):
			new_dialogue_box.set_position(new_dialogue_box.get_position() + player.find_door(2).get_camera_location())
		if (computer_index == 4):
			new_dialogue_box.set_position(new_dialogue_box.get_position() + player.find_door(5).get_camera_location())
		dialogue = true
		current_dialogue_tree = 0
		new_dialogue_box.update_message(dialogue_trees[0][0])
		current_dialogue_box = new_dialogue_box

func end_dialogue():
	current_player.end_dialogue()
	current_dialogue_box.close()
	dialogue = false

func _process(delta: float) -> void:
	if (dialogue):
		if (Input.is_action_just_pressed("interact")):
			current_dialogue_step += 1
			if (current_dialogue_step <= dialogue_trees[current_dialogue_tree].size() - 1):
				current_dialogue_box.update_message(dialogue_trees[current_dialogue_tree][current_dialogue_step])
			else:
				end_dialogue()
			
			dialogue_cooldown.start()
			dialogue_cooldown_active = true

func _on_dialogue_cooldown_timeout() -> void:
	dialogue_cooldown_active = false
