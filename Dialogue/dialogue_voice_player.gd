extends AudioStreamPlayer


class_name DialogueVoicePlayer

var random_number_gen := RandomNumberGenerator.new()

func _ready() -> void:
	random_number_gen.randomize()

func play_modulated(from_position := 0.0) -> void:
	pitch_scale = random_number_gen.randf_range(0.95, 1.08)
	play(from_position)
