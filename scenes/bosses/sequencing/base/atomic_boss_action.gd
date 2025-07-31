## Single action that runs over time with timer and process loop
class_name AtomicBossAction extends BossAction

var timer: Timer

func _ready():
	super._ready()
	_set_timer()

func _process(delta):
	if not timer.is_stopped(): # if timer is running, perform action
		_perform_action(delta)

## Entry point for action; kicks it off
func execute(boss: Node):
	super.execute(boss)
	timer.start()

## Defines what the action actually does to/with the boss
func _perform_action(delta: float):
	pass

func _set_timer():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = duration
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	completed.emit(boss_node)
