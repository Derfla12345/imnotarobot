extends Node2D


@export var player_controller: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var sprite: Sprite2D

var last_direction = Vector2(0, 1)

func _process(delta: float) -> void:
	if (player_controller.velocity != Vector2(0, 0)):
		match player_controller.direction:
			Vector2(-1, 0): #left
				animation_player.play("walk_left")
			Vector2(1, 0): # right
				animation_player.play("walk_right")
			Vector2(0, -1): # up
				animation_player.play("walk_up")
			Vector2(0, 1): # down
				animation_player.play("walk_down")
		last_direction = player_controller.direction
	else:
		match last_direction:
			Vector2(-1, 0): #left
				animation_player.play("idle_left")
			Vector2(1, 0): # right
				animation_player.play("idle_right")
			Vector2(0, -1): # up
				animation_player.play("idle_up")
			Vector2(0, 1): # down
				animation_player.play("idle_down")
