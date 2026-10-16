extends Node2D

@onready var sfx_bump = $"../../SFXBump"

var window_size_x = DisplayServer.window_get_size().x
var window_size_y = DisplayServer.window_get_size().y

var move_to_true_x = window_size_y * 0.6
var move_to_true_y = window_size_y * 0.45

var last_mouse_pos_x
var last_mouse_pos_y


func warp_mouse_from_bound(delta_x: float, delta_y: float) -> void:
	last_mouse_pos_x = get_local_mouse_position().x + move_to_true_x
	last_mouse_pos_y = get_local_mouse_position().y + move_to_true_y
	var new_mouse_pos = Vector2(last_mouse_pos_x + delta_x, last_mouse_pos_y + delta_y)
	sfx_bump.play()
	get_viewport().warp_mouse(new_mouse_pos)

func _on_bound_top_mouse_entered() -> void:
	warp_mouse_from_bound(0, -100)

func _on_bound_left_mouse_entered() -> void:
	warp_mouse_from_bound(-100, 0)

func _on_bound_right_mouse_entered() -> void:
	warp_mouse_from_bound(300, 0)

func _on_bound_bottom_mouse_entered() -> void:
	warp_mouse_from_bound(0, 100)

func _on_bound_center_mouse_entered() -> void:
	warp_mouse_from_bound(0, 100)
