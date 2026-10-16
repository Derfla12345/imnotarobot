extends TextureButton


var toggle_state: bool = false
var selected_texture = load("res://Captchas/Scratchoff/selected.png")

func _on_pressed() -> void:
	toggle_state = !toggle_state
	if (toggle_state):
		texture_normal = selected_texture
	else:
		texture_normal = null
