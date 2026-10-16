extends Node2D

@onready var ambience = $Ambience
var offsets = [Vector2(0, 0), Vector2(6000, 0)] # list of position offsets for the ingame screens

func get_offset(index: int) -> Vector2:
	if (index > 0 and index <= offsets.size()):
		return offsets[index]
	else:
		print("index out of range in area_1.gd - get_offset, returning 0, 0")
		return Vector2(0, 0)

func _ready():
	ambience.play()
