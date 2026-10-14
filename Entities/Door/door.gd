extends Area2D


# door_id is the ID of this door, door_send_id is the ID of the door that this door leads to
# set both using the godot UI rather than editing this text
@export var door_id: int = 0
@export var door_send_id: int = 0
@export var exit_location_index: int = 0 # 0123 for NESW
@export var camera_location: Vector2
@export var exit_offset: Vector2

@onready var receive_door = find_receive_door(door_send_id)

func interact(player: CharacterBody2D):
	if (receive_door):
		if (receive_door.get_exit_location()):
			player.enter_door(receive_door)

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

func get_door_id() -> int:
	return door_id

func get_exit_location():
	return (position + exit_offset)

func get_camera_location():
	return camera_location
