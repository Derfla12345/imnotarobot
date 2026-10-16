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
			_:
				if (last_direction[0] > 0 and last_direction[1] > 0):
					animation_player.play("idle_down")
				else:
					animation_player.play("idle_up")
		if (not player_controller.activity_lock):
			if (Input.is_action_just_pressed("move_left")):
				animation_player.play("idle_left")
				last_direction = Vector2(-1, 0)
			elif (Input.is_action_just_pressed("move_right")):
				animation_player.play("idle_right")
				last_direction = Vector2(1, 0)
			elif (Input.is_action_just_pressed("move_up")):
				animation_player.play("idle_up")
				last_direction = Vector2(0, -1)
			elif (Input.is_action_just_pressed("move_down")):
				animation_player.play("idle_down")
				last_direction = Vector2(0, 1)
