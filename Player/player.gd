extends CharacterBody2D


@onready var area_camera = get_area_camera()
@onready var room_1_and_2_music = $"../Room1And2Music"
@onready var room_3_music = $"../Room3Music"
@onready var sfx_door = $SFXDoor
@onready var sfx_metagame_success = $SFXSuccess2
@onready var sfx_end_door_open = $SFXEndDoorOpen

@export var progress = [0, 0, 0]
@export var crt_filter: CanvasLayer
@export var room2: Sprite2D

var interactable_object = false
var activity_lock: bool = false
var speed: int = 1250
var in_dialogue = false
var direction
var metagame_crt: bool = false
var endgame: bool = false

func _physics_process(delta: float) -> void:
	if (not activity_lock):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = direction * speed
		move_and_slide()
	
		if (Input.is_action_just_pressed("interact")):
			if interactable_object and interactable_object.has_method("interact"):
				interactable_object.interact(self)
	
	if (in_dialogue):
		pass
	
	#if velocity.length() > 0.0:
		#PlayerAnimator.play_walk_animation()
	#else:
		#PlayerAnimator.play_idle_animation()

func _ready():
	room_1_and_2_music.play()

func _process(delta: float) -> void:
	if(metagame_crt):
		crt_filter.visible = true
	else:
		crt_filter.visible = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	interactable_object = area

func _on_area_2d_area_exited(area: Area2D) -> void:
	interactable_object = false

func set_activity_lock(new_val: bool):
	activity_lock = new_val

func start_dialogue():
	in_dialogue = true
	set_activity_lock(true)

func end_dialogue():
	in_dialogue = false
	set_activity_lock(false)

func enter_door(door: Area2D):
	position = door.get_exit_location()
	area_camera.position = door.get_camera_location()
	sfx_door.play()
	
	if door.name == "Door4":
		if room_1_and_2_music.playing:
			room_1_and_2_music.stop()
			room_3_music.play()
	
func get_area_camera():
	var found_node: Camera2D
	
	if (get_parent()):
		var children = get_parent().get_children()
		for i in children:
			if i is Camera2D:
				found_node = i
	
	return found_node

func increment_progress(computer_index: int):
	progress[computer_index] += 1
	# maybe put some failsafe that doesn't let progress go past the max, once we know what the max is

func get_progress(computer_index: int) -> int:
	return progress[computer_index]

func set_metagame_crt(status: bool):
	metagame_crt = status

func get_metagame_crt() -> bool:
	return metagame_crt

func find_door(target_id: int):
	var siblings = null
	var target = null
	var found_door_id: int = -1
	
	if get_parent():
		siblings = get_parent().get_children()
	
	# check each sibling for get_door_id(), return the door that matches if it exists
	if (siblings):
		for i in siblings:
			if (i.has_method("get_door_id")):
				found_door_id = i.get_door_id()
				if (target_id == found_door_id):
					target = i
	
	return target

func play_metagame_success():
	sfx_metagame_success.play()

func play_end_door_open():
	sfx_end_door_open.play()

func get_endgame():
	return endgame

func set_endgame(status: bool):
	endgame = status
