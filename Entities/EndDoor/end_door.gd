extends Area2D


@export var dialogue_cooldown: Timer

@onready var dialogue_box = preload("res://Dialogue/dialogue.tscn")

var current_dialogue_box
var dialogue: bool = false
var dialogue_cooldown_active: bool = false
var current_player
var door_id = -1

@export var open: bool = false

func _process(delta: float) -> void:
	if (dialogue and Input.is_action_just_pressed("interact")):
		current_player.end_dialogue()
		current_dialogue_box.close()
		dialogue = false
		
		dialogue_cooldown.start()
		dialogue_cooldown_active = true

func interact(player: CharacterBody2D):
	if (open):
		get_tree().change_scene_to_file("res://Areas/Credits/credits.tscn")
	else:
		if (not dialogue_cooldown_active):
			player.start_dialogue()
			var new_dialogue_box = dialogue_box.instantiate()
			get_tree().root.add_child(new_dialogue_box)
			new_dialogue_box.update_message("It won't budge.")
			new_dialogue_box.set_position(new_dialogue_box.get_position() + player.find_door(2).get_camera_location())
			dialogue = true
			
			current_dialogue_box = new_dialogue_box
	
	current_player = player

func _on_dialogue_cooldown_timeout() -> void:
	dialogue_cooldown_active = false

func get_door_id() -> int:
	return door_id

func get_open():
	return open

func set_open(status: bool):
	open = status
