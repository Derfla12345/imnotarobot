extends Area2D


@onready var captcha_test = preload("res://Captchas/CaptchaTest/captcha_test.tscn")

func interact(player: CharacterBody2D):
	var captcha_test_instance = captcha_test.instantiate()
	get_tree().root.add_child(captcha_test_instance)
	player.set_activity_lock(true)
	captcha_test_instance.set_player(player)
