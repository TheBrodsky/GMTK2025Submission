extends Node2D

@onready var overlay := %FadeOverlay
@onready var return_button := %ReturnButton

func _ready():
	overlay.on_complete_fade_out.connect(_on_fade_overlay_on_complete_fade_out)
	return_button.pressed.connect(_on_return_button_pressed)
	return_button.mouse_entered.connect(_on_return_button_mouse_entered)
	
	overlay.visible = true
	#return_button.grab_focus()

func _on_fade_overlay_on_complete_fade_out():
	get_tree().change_scene_to_file("res://scenes/main_menu_scene.tscn")

func _on_return_button_pressed():
	$UiPress.play()
	overlay.fade_out()

func _on_return_button_mouse_entered():
	$UiHover.play()
	
