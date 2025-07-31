extends Node2D
class_name GameOverScene;

@onready var fade_overlay: FadeOverlay = %FadeOverlay
const MAIN_MENU_SCENE := "res://scenes/main_menu_scene.tscn";
const INGAME_SCENE := "res://scenes/ingame_scene.tscn";

var next_scene: String;

func _on_restart_button_pressed() -> void:
	next_scene = INGAME_SCENE;
	fade_overlay.fade_out();

func _on_return_to_main_menu_button_pressed() -> void:
	next_scene = MAIN_MENU_SCENE;
	fade_overlay.fade_out();

func _on_exit_button_pressed() -> void:
	get_tree().quit();

func _on_fade_overlay_on_complete_fade_out() -> void:
	get_tree().change_scene_to_file(next_scene);
