extends Node2D

@export var game_scene: PackedScene

@onready var overlay := %FadeOverlay
@onready var easy_button := %EasyButton
@onready var medium_button := %MediumButton
@onready var hard_button := %HardButton
@onready var back_button := %BackButton

var selected_difficulty: Global.BossDifficulty
var next_scene: PackedScene

func _ready() -> void:
	overlay.visible = true
	
	# Connect button signals
	easy_button.pressed.connect(_on_easy_button_pressed)
	medium_button.pressed.connect(_on_medium_button_pressed)
	hard_button.pressed.connect(_on_hard_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	
	overlay.on_complete_fade_out.connect(_on_fade_overlay_on_complete_fade_out)

func _on_easy_button_pressed() -> void:
	selected_difficulty = Global.BossDifficulty.EASY
	_start_game()

func _on_medium_button_pressed() -> void:
	selected_difficulty = Global.BossDifficulty.MEDIUM
	_start_game()

func _on_hard_button_pressed() -> void:
	selected_difficulty = Global.BossDifficulty.HARD
	_start_game()

func _on_back_button_pressed() -> void:
	next_scene = load("res://scenes/main_menu_scene.tscn")
	overlay.fade_out()

func _start_game() -> void:
	# Store the selected difficulty globally
	Global.selected_difficulty = selected_difficulty
	next_scene = game_scene
	overlay.fade_out()

func _on_fade_overlay_on_complete_fade_out() -> void:
	# Clear save if starting new game (not going back)
	if next_scene == game_scene and SaveGame.has_save():
		SaveGame.delete_save()
	
	get_tree().change_scene_to_packed(next_scene)
