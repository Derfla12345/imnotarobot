extends Node2D


var offsets = [Vector2(0, 0), Vector2(6000, 0)] # list of position offsets for the ingame screens

func get_offset(index: int) -> Vector2:
	if (index > 0 and index <= offsets.size()):
		return offsets[index]
	else:
		print("index out of range in area_1.gd - get_offset, returning 0, 0")
		return Vector2(0, 0)


# door controller (hate how you need individual function calls for this)
#func _on_door_1_body_entered(body: Node2D) -> void:
	#if body is CharacterBody2D:
		#print("door1 entered")
#
#func _on_door_2_body_entered(body: Node2D) -> void:
	#if body is CharacterBody2D:
		#print("door2 entered")
