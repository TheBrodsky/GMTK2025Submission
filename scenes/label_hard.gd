extends Label

func _ready() -> void:
	text = "CLONE #" + str(UserSettings.attempt_counter).pad_zeros(3)
	UserSettings.attempt_counter = 0
