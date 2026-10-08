extends CharacterBody2D


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	move_and_slide()
	
	#if velocity.length() > 0.0:
		#PlayerAnimator.play_walk_animation()
	#else:
		#PlayerAnimator.play_idle_animation()




# door controller
# (i don't like the separate function calls and it being in player.gd but it might be the best way to have multiple doors on one screen from what i looked at)
func _on_door_1_body_entered(body: Node2D) -> void:
	print("door1")

func _on_door_2_body_entered(body: Node2D) -> void:
	print("door2")
