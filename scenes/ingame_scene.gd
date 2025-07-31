extends Node2D

@onready var fade_overlay = %FadeOverlay
@onready var pause_overlay = %PauseOverlay
@onready var player_hud = %PlayerHUD

@export var clone_manager: CloneManager;
@export var game_over_screen: PackedScene;

var next_scene: PackedScene;

func _ready() -> void:
	fade_overlay.visible = true
	
	if SaveGame.has_save():
		SaveGame.load_game(get_tree())
	
	pause_overlay.game_exited.connect(_save_game);
	
	clone_manager.spawn_normal_player();

func _input(event) -> void:
	if event.is_action_pressed("pause") and not pause_overlay.visible:
		get_viewport().set_input_as_handled()
		get_tree().paused = true
		pause_overlay.grab_button_focus()
		pause_overlay.visible = true
		player_hud.visible = false;
		
func _save_game() -> void:
	SaveGame.save_game(get_tree())

func _on_game_loop_manager_cause_hard_reset() -> void:
	fade_overlay.fade_out();
	next_scene = game_over_screen;

func _on_fade_overlay_on_complete_fade_out() -> void:
	get_tree().change_scene_to_packed(next_scene)
