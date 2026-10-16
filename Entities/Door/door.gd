extends Area2D


# door_id is the ID of this door, door_send_id is the ID of the door that this door leads to
# set both using the godot UI rather than editing this text
@export var door_id: int = 0
@export var door_send_id: int = 0
@export var exit_location_index: int = 0 # 0123 for NESW
@export var camera_location: Vector2
@export var exit_offset: Vector2
@export var locked: bool = true
@export var lock_password: String = ""
@export var cooldown_timer: Timer

@onready var receive_door = find_receive_door(door_send_id)
@onready var dialogue_box = preload("res://Dialogue/dialogue.tscn")
@onready var input_field = preload("res://Dialogue/PasswordField.tscn")

var locked_sequence_occurring: bool = false
var current_dialogue_box: Control
var current_input_field: Control
var current_player: CharacterBody2D
var metagame: bool = false
var cooldown: bool = false

func _process(delta: float) -> void:
	if(current_dialogue_box and current_dialogue_box.finished):
		if (Input.is_action_just_pressed("interact")):
			current_dialogue_box.close()
			if metagame:
				cooldown = true
				current_player.set_activity_lock(false)
				cooldown_timer.start()
			else:
				current_input_field = receive_password_input()
			# ^i don't know why it doesn't focus this input box. should put a submit button inside
			# PasswordField.tscn so it feels more normal to move the mouse here

func interact(player: CharacterBody2D):
	if (not cooldown):
		if (locked):
			current_dialogue_box = start_locked_sequence(player)
		else:
			if (receive_door.get_exit_location()):
				player.enter_door(receive_door)
	current_player = player

# locate the node for the door we're trying to send to. returns null if the door isn't found
func find_receive_door(target_id: int):
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
				if (door_send_id == found_door_id):
					target = i
	
	return target

# begin the sequence for unlocking the door (add a dialogue box)
func start_locked_sequence(player: CharacterBody2D):
	player.start_dialogue()
	#locked_sequence_occurring = true
	
	var new_dialogue_box = dialogue_box.instantiate()
	get_tree().root.add_child(new_dialogue_box)
	new_dialogue_box.set_position(new_dialogue_box.get_position() + camera_location)
	if(player.get_metagame_crt()):
		metagame = true
		new_dialogue_box.update_message("The door seems to be locked electronically.")
	else:
		new_dialogue_box.update_message("The door seems to have some sort of password lock.")
	
	return new_dialogue_box

# add an input field for the door lock
func receive_password_input() -> Control:
	var new_input_field = input_field.instantiate()
	get_tree().root.add_child(new_input_field)
	new_input_field.set_position(new_input_field.get_position() + camera_location)
	new_input_field.set_answer(lock_password)
	new_input_field.set_door(self)
	
	return new_input_field

func get_door_id() -> int:
	return door_id

func get_exit_location():
	return (position + exit_offset)

func get_camera_location():
	return camera_location

func get_locked() -> bool:
	return locked

func set_locked(lock_state: bool) -> void:
	locked = lock_state

func close_dialogue() -> void:
	if (current_player):
		current_player.set_activity_lock(false)

func set_lock_password(new_password: String) -> void:
	lock_password = new_password

func _on_cooldown_timeout() -> void:
	cooldown = false
