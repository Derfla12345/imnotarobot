extends Area2D


@export var door_id: int = 0
@export var door_send_id: int = 0

@onready var receive_door = find_receive_door(door_send_id)
@onready var player = find_player()

func _on_body_entered(body: Node2D) -> void:
	if (receive_door and player):
		if (player.get_can_door()):
			player.set_can_door(false)
			player.position = receive_door.position

func _on_body_exited(body: Node2D) -> void:
	if (player):
		player.set_can_door(true)

# get the player node for player teleporting
func find_player():
	var player = null
	
	if (get_parent()):
		player = get_parent().find_child("Player")
	
	return player

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
