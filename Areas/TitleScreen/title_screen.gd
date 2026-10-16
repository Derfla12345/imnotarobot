extends Node2D


@onready var sfx_select = $SFXSelect

func _on_play_pressed() -> void:
	sfx_select.play()
	get_tree().change_scene_to_file("res://Areas/area_1.tscn")

func _on_credits_pressed() -> void:
	sfx_select.play()
	get_tree().change_scene_to_file("res://Areas/Credits/credits.tscn")

func _on_quit_pressed() -> void:
	sfx_select.play()
	await get_tree().create_timer(0.1).timeout # wait for select
	get_tree().quit()
