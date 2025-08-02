extends Node2D

@export var player: CharacterBody2D

func _process(delta: float) -> void:
	look_at(player.position)
