extends Node2D

# when adding textures, make sure to place them in the bottom right quadrant in 2d view
@export var wait_texture = CompressedTexture2D
@export var hover_texture = CompressedTexture2D

func _ready() -> void:
	self.texture = hover_texture

func _process (delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	global_position = get_global_mouse_position()
	
	if get_viewport().gui_get_hovered_control() == null:
		self.texture = wait_texture
	else:
		self.texture = hover_texture
