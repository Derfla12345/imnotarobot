extends PanelContainer


@export var texture: TextureRect
@export var label: RichTextLabel
@onready var red_texture = preload("res://Captchas/Wordle/wordle_red.png")
@onready var blue_texture = preload("res://Captchas/Wordle/wordle_blue.png")
@onready var yellow_texture = preload("res://Captchas/Wordle/wordle_yellow.png")
@onready var textures = [red_texture, blue_texture, yellow_texture]

func set_texture(texture_index: int):
	texture.set_texture(textures[texture_index])

func set_label(label_content: String):
	label.set_text(label_content)

func remove():
	queue_free()
