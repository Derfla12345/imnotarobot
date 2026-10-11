extends Node2D

const MOVE_TO_TRUE_X = 347.5
const MOVE_TO_TRUE_Y = 254

var last_mouse_pos_x
var last_mouse_pos_y

func warp_mouse_from_bound(delta_x: float, delta_y: float) -> void:
	last_mouse_pos_x = get_global_mouse_position().x + MOVE_TO_TRUE_X
	last_mouse_pos_y = get_global_mouse_position().y + MOVE_TO_TRUE_Y
	var new_mouse_pos = Vector2(last_mouse_pos_x + delta_x, last_mouse_pos_y + delta_y)
	get_viewport().warp_mouse(new_mouse_pos)

func _on_bound_top_mouse_entered() -> void:
	warp_mouse_from_bound(0, -50)

func _on_bound_left_mouse_entered() -> void:
	warp_mouse_from_bound(-50, 0)

func _on_bound_right_mouse_entered() -> void:
	warp_mouse_from_bound(50, 0)

func _on_bound_bottom_mouse_entered() -> void:
	warp_mouse_from_bound(0, 50)

func _on_bound_center_mouse_entered() -> void:
	warp_mouse_from_bound(0, 50)
