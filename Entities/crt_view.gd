extends Control


var offset = Vector2(-1673, -1194)
@onready var sub_viewport = $SubViewportContainer/SubViewport
@onready var cursor = preload("res://Entities/Cursors/cursor.tscn").instantiate()

##func _ready():
	#sub_viewport.add_child.call_deferred(cursor)
	##remove_child.call_deferred(cursor)

##func _exit_tree() -> void:
	#sub_viewport.remove_child.call_deferred(cursor)
	##remove_child.call_deferred(cursor)

func get_sub_viewport() -> SubViewport:
	return sub_viewport

func start_captcha(captcha):
	var captcha_instance = captcha.instantiate()
	#sub_viewport.add_child(captcha_instance)
	get_tree().root.add_child(captcha_instance)
	#var captcha_test = get_parent().get_parent().get_parent()
	#captcha_test.add_child(captcha_instance) # need to change this so it can appear under a transparent image
	#captcha_instance.set_position(captcha_instance.position - offset)
	
	return captcha_instance
