extends AudioStreamPlayer2D

const MENU_FULL = preload("res://assets/Sounds/Music/MenuFull.mp3")
const COMBAT = preload("res://assets/Sounds/Music/Combat.mp3")

func _play_music(music: AudioStream, volume = 0.0) -> void:
	if stream == music:
		return;
	
	stream = music;
	volume_db = volume;
	play()

func play_main_menu_music() -> void:
	_play_music(MENU_FULL, 8.0)

func play_combat_music() -> void:
	_play_music(COMBAT, 0.0);

func play_fx(stream: AudioStream, volume = 0.0) -> void:
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream;
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = volume;
	add_child(fx_player);
	fx_player.play()
	
	await fx_player.finished;
	fx_player.queue_free();
