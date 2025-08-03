extends ProgressBar

func _ready() -> void:
	value = max_value
	modulate.a = 0.75
	
	
func PLACEHOLDER():
	value = max_value - 1
