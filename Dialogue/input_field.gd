extends Control


# this scene expects to be the child of a door
@export var position_offset = Vector2(-426, 1071)
@export var scale_offset = Vector2(5, 5)
@export var input_field: LineEdit

var door: Area2D
var answer = ""

func _ready():
	set_position(position_offset)
	set_scale(scale_offset)

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("enter")):
		verify_answer()

func verify_answer():
	var submission = input_field.get_text().to_lower()
	if (submission == answer):
		door.set_locked(false)
	door.close_dialogue()
	close()

func close():
	queue_free()

func set_answer(new_answer: String):
	answer = new_answer

func set_door(new_door: Area2D):
	door = new_door
