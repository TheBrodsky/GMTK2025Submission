extends Node;
class_name CloneManager;

const PLAYER = preload("res://scenes/player/player.tscn");

# we need to individually keep track of all recordings.
var input_recordings: Array[InputRecording] = [];

func _on_player_should_die(player: Player) -> void:
	# Append new recording
	input_recordings.append(player.input_recording);
	# despawn dead player
	player.queue_free();
	
	# loop through all recordings and spawn a new player with that recording
	for recording in input_recordings:
		var new_player = PLAYER.instantiate();
		new_player.input_recording = recording;
		new_player.mode = Global.PlayerMode.Clone;
		get_tree().root.add_child(new_player);
	
	# spawn new normal player
	spawn_normal_player();

func spawn_normal_player() -> void:
	var new_player = PLAYER.instantiate();
	new_player.should_die.connect(_on_player_should_die);
	get_tree().root.add_child(new_player);
	
