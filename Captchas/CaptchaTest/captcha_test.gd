extends Node2D


var mouseover: bool = false
var player: CharacterBody2D

func _process(delta: float) -> void:
	if (mouseover and Input.is_action_just_pressed("click")):
		if (player.has_method("set_movement_lock")):
			player.set_movement_lock(false)
		queue_free()

func _on_area_2d_mouse_entered() -> void:
	mouseover = true

func _on_area_2d_mouse_exited() -> void:
	mouseover = false

func set_player(new_player: CharacterBody2D):
	player = new_player
