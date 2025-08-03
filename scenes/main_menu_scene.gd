extends Node2D

@export var difficulty_scene:PackedScene
@export var settings_scene:PackedScene
@export var credits_scene:PackedScene

@onready var overlay := %FadeOverlay
@onready var credits_button := %CreditsButton
@onready var new_game_button := %NewGameButton
@onready var settings_button := %SettingsButton
@onready var exit_button := %ExitButton

var next_scene = difficulty_scene
var new_game = true

func _ready() -> void:
	overlay.visible = true
	new_game_button.disabled = difficulty_scene == null
	settings_button.disabled = settings_scene == null
	credits_button.disabled = settings_scene == null
	
	# connect signals
	new_game_button.pressed.connect(_on_play_button_pressed)
	credits_button.pressed.connect(_on_credits_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	new_game_button.mouse_entered.connect(_on_play_button_mouse_entered)
	credits_button.mouse_entered.connect(_on_credits_button_mouse_entered)
	settings_button.mouse_entered.connect(_on_settings_button_mouse_entered)
	exit_button.mouse_entered.connect(_on_exit_button_mouse_entered)
	overlay.on_complete_fade_out.connect(_on_fade_overlay_on_complete_fade_out)
	
	#if credits_button.visible:
		#credits_button.grab_focus()
	#else:
		#new_game_button.grab_focus()

func _on_settings_button_pressed() -> void:
	$UiPress.play()
	new_game = false
	next_scene = settings_scene
	overlay.fade_out()
	
func _on_play_button_pressed() -> void:
	$UiPress.play()
	next_scene = difficulty_scene
	overlay.fade_out()
	
func _on_credits_button_pressed() -> void:
	$UiPress.play()
	new_game = false
	next_scene = credits_scene
	overlay.fade_out()

func _on_exit_button_pressed() -> void:
	$UiPress.play()
	get_tree().quit()

func _on_settings_button_mouse_entered() -> void:
	$UiHover.play()
	
func _on_play_button_mouse_entered() -> void:
	$UiHover.play()
	
func _on_credits_button_mouse_entered() -> void:
	$UiHover.play()

func _on_exit_button_mouse_entered() -> void:
	$UiHover.play()
	
func _on_fade_overlay_on_complete_fade_out() -> void:
	if new_game and SaveGame.has_save():
		SaveGame.delete_save()
	get_tree().change_scene_to_packed(next_scene)
