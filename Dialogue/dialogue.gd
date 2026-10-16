extends Control
class_name Dialogue


@onready var content := get_node("Content") as RichTextLabel
@onready var type_timer := get_node("TypeTimer") as Timer
@onready var pause_timer := get_node("PauseTimer") as Timer
@onready var dialogue_voice_player := get_node("DialogueVoicePlayer") as AudioStreamPlayer
@onready var player := get_node("res://Player/player.gd") as CharacterBody2D

@export var font: Font
@export var position_offset = Vector2(-2162, 734)
@export var scale_offset = Vector2(7, 7)

var playing_voice = false
var finished: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_position(position + position_offset)
	set_scale(scale + scale_offset)
	await(get_tree().create_timer(1.0).timeout)

func _process(delta: float) -> void:
	pass

func update_message(message: String) -> void:
	finished = false
	content.set_use_bbcode(true)
	content.bbcode_text = message
	content.add_theme_font_override("LindsayFont", font)
	content.visible_characters = 0
	type_timer.start()
	playing_voice = true
	dialogue_voice_player.play_modulated(0)

func _on_type_timer_timeout() -> void:
	if content.visible_characters < content.text.length():
		content.visible_characters += 1
	else:
		type_timer.stop()
		playing_voice = false
	finished = true

func _on_dialogue_voice_player_finished() -> void:
	if playing_voice:
		dialogue_voice_player.play_modulated(0)

func close() -> void:
	queue_free()
