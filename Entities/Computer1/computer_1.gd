extends Area2D


var captcha_test = preload("res://Captchas/CaptchaTest/captcha_test.tscn").instantiate()

func interact(player: CharacterBody2D):
	get_tree().root.add_child(captcha_test)
	player.set_activity_lock(true)
	captcha_test.set_player(player)
