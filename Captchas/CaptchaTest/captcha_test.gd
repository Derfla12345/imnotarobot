extends Node2D

@onready var cursor = preload("res://Entities/Cursors/cursor.tscn").instantiate()

var player: CharacterBody2D
var computer_off: bool = false

func _ready():
	add_child.call_deferred(cursor)

func _on_power_button_pressed() -> void:
	computer_off = true
	
# will come back to this later since a check like this in _process isn't that necessary now
func _process(delta: float) -> void:
	if computer_off:
		if (player and player.has_method("set_activity_lock")):
			player.set_activity_lock(false)
		queue_free()

func set_player(new_player: CharacterBody2D):
	player = new_player

func _exit_tree() -> void:
	remove_child.call_deferred(cursor)
