extends Node2D


# door controller (hate how you need individual function calls for this)
func _on_door_1_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		print("door1 entered")

func _on_door_2_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		print("door2 entered")
