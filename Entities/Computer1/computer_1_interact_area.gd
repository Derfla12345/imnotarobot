extends Area2D


@onready var captcha_test = preload("res://Captchas/CaptchaTest/captcha_test.tscn")
@onready var computer_index = get_parent().get_computer_index()

@onready var sfx_select = $"../SFXSelect"

func get_computer_index():
	return computer_index

func interact(player: CharacterBody2D):
	var captcha_test_instance = captcha_test.instantiate()
	get_tree().root.add_child(captcha_test_instance)
	player.set_activity_lock(true)
	captcha_test_instance.set_player(player)
	captcha_test_instance.set_computer_index(computer_index)
	captcha_test_instance.set_progress(player.get_progress(computer_index))
	captcha_test_instance.set_progress_state()
