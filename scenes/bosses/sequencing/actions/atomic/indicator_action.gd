## Displays an indicator image during the wait period with optional flashing
class_name IndicatorAction extends WaitAction

@export var indicator_image: Texture2D
@export var indicator_position: Vector2 = Vector2.ZERO
@export var flash_enabled: bool = true
@export var flash_frequency: float = 3.0

var indicator_sprite: Sprite2D
var time_elapsed: float = 0.0

func _perform_action(delta: float):
	time_elapsed += delta
	
	if not indicator_sprite and indicator_image:
		_create_indicator()
	
	if indicator_sprite and flash_enabled:
		_update_flash()

func _create_indicator():
	indicator_sprite = Sprite2D.new()
	indicator_sprite.texture = indicator_image
	indicator_sprite.position = indicator_position
	get_tree().root.add_child(indicator_sprite)

func _update_flash():
	var flash_value = sin(time_elapsed * flash_frequency * 2.0 * PI)
	var visible = flash_value > 0.0
	indicator_sprite.visible = visible

func _on_action_completed():
	super._on_action_completed()
	if indicator_sprite:
		indicator_sprite.queue_free()
		indicator_sprite = null