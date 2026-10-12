extends CharacterBody2D


@onready var area_camera = get_area_camera()
@onready var progress: int = 0

var interactable_object = false
var activity_lock: bool = false

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

func enter_door(door: Area2D):
	position = door.get_exit_location()
	area_camera.position = door.get_camera_location()
	
func get_area_camera():
	var found_node: Camera2D
	
	if (get_parent()):
		var children = get_parent().get_children()
		for i in children:
			if i is Camera2D:
				found_node = i
	
	return found_node

func increment_progress():
	progress += 1
	# maybe put some failsafe that doesn't let progress go past the max, once we know what the max is

func get_progress() -> int:
	return progress
