extends Node;
class_name CloneManager;

const PLAYER = preload("res://scenes/player/player.tscn");

signal new_player_spawned(player: Player); # gets emitted whenever a new player gets spawned

# we need to individually keep track of all recordings.
var input_recordings: Array[InputRecording] = [];
var active_player: Player;

func spawn_normal_player() -> void:
	var new_player = PLAYER.instantiate();
	get_tree().root.call_deferred("add_child", new_player);
	active_player = new_player;
	new_player_spawned.emit(new_player);

func _on_game_loop_manager_cause_soft_reset() -> void:
	# Append new recording
	input_recordings.append(active_player.input_recording);
	
	# loop through all recordings and spawn a new player with that recording as a clone
	for recording in input_recordings:
		var new_player = PLAYER.instantiate();
		new_player.input_recording = recording;
		new_player.mode = Global.PlayerMode.Clone;
		get_tree().root.call_deferred("add_child", new_player);
	
	# spawn new normal player
	spawn_normal_player();
