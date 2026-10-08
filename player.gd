extends CharacterBody2D


var interactable_object = false
var activity_lock: bool = false
var can_door: bool = true

func _physics_process(delta: float) -> void:
	if (not activity_lock):
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = direction * 125
		move_and_slide()
	
	if (Input.is_action_just_pressed("interact")):
		if interactable_object and interactable_object.has_method("interact"):
			interactable_object.interact(self)
	
	#if velocity.length() > 0.0:
		#PlayerAnimator.play_walk_animation()
	#else:
		#PlayerAnimator.play_idle_animation()

func _on_area_2d_area_entered(area: Area2D) -> void:
	interactable_object = area

func _on_area_2d_area_exited(area: Area2D) -> void:
	interactable_object = false

func set_activity_lock(new_val: bool):
	activity_lock = new_val

func set_can_door(new_val: bool):
	can_door = new_val

func get_can_door() -> bool:
	return can_door
