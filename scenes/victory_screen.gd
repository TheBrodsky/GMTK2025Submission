extends Node2D
class_name VictoryScreen;

@onready var fade_overlay: FadeOverlay = %FadeOverlay
const MAIN_MENU_SCENE := "res://scenes/main_menu_scene.tscn";
@onready var trial_counter: Label = $UI/CenterContainer/VSplitContainer/VBoxContainer2/TrialCounter
@onready var clone_number: Label = $UI/CenterContainer/VSplitContainer/VBoxContainer2/CloneNumber
const PLAYER_VICTORY = preload("res://assets/Sounds/SFX/PlayerVictory.mp3")

var next_scene: String;

func _ready() -> void:
	trial_counter.text = "TRIAL #" + str(UserSettings.hard_resets + 1).pad_zeros(3)
	UserSettings.hard_resets = 0
	
	clone_number.text = "CLONE #" + str(UserSettings.attempt_counter).pad_zeros(3)
	UserSettings.attempt_counter = 0;
	
	AudioPlayer.play_fx(PLAYER_VICTORY);
	AudioPlayer.play_main_menu_music();

func _on_return_to_main_menu_button_pressed() -> void:
	$UiPress.play()
	next_scene = MAIN_MENU_SCENE;
	fade_overlay.fade_out();

func _on_exit_button_pressed() -> void:
	$UiPress.play()
	get_tree().quit();

func _on_fade_overlay_on_complete_fade_out() -> void:
	get_tree().change_scene_to_file(next_scene);

func _on_return_to_main_menu_button_mouse_entered() -> void:
	$UiHover.play()

func _on_exit_button_mouse_entered() -> void:
	$UiHover.play()
