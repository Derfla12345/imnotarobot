extends Node2D

@onready var cursor = preload("res://Entities/Cursors/cursor.tscn").instantiate()


func _on_bound_top_mouse_entered() -> void:
	var last_mouse_pos_x = get_global_mouse_position().x
	var last_mouse_pos_y = get_global_mouse_position().y
	var new_mouse_pos = Vector2(last_mouse_pos_x, last_mouse_pos_y)
	get_viewport().warp_mouse(new_mouse_pos)
#
#func _on_bound_left_mouse_entered() -> void:
	#get_viewport().warp_mouse(
#
#func _on_bound_right_mouse_entered() -> void:
	#get_viewport().warp_mouse(
#
#func _on_bound_bottom_mouse_entered() -> void:
	#get_viewport().warp_mouse(
