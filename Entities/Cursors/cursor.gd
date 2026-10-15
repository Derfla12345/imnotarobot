extends Node2D

# when adding textures, make sure to place them in the bottom right quadrant in 2d view
@export var wait_texture = CompressedTexture2D
@export var hover_texture = CompressedTexture2D
@export var grabbing_texture = AnimatedSprite2D

@export var grabbing: bool = false

func _ready() -> void:
	self.texture = wait_texture

func _process (delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	global_position = get_global_mouse_position()
	
	if (grabbing):
		self.texture = null
		grabbing_texture.visible = true
	else:
		grabbing_texture.visible = false
		if get_viewport().gui_get_hovered_control() is BaseButton:
			self.texture = hover_texture
		else:
			self.texture = wait_texture

func set_grabbing(is_grabbing: bool):
	grabbing = is_grabbing
