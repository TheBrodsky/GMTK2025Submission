## Multiple actions that run simultaneously, completes when all children complete
class_name CompositeBossAction extends BossAction

var sub_actions: Array[BossAction] = []
var completed_actions: int = 0

func _ready():
	_get_sub_actions()
	_calculate_duration()
	
	for sub_action in sub_actions:
		sub_action.completed.connect(_on_sub_action_completed)

func execute(boss: Node):
	super.execute(boss)
	completed_actions = 0
	for sub_action in sub_actions:
		sub_action.execute(boss)

func _get_sub_actions():
	sub_actions.clear()
	for child in get_children():
		if child is BossAction:
			sub_actions.append(child)

func _calculate_duration():
	var max_duration = 0.0
	for sub_action in sub_actions:
		max_duration = max(max_duration, sub_action.duration)
	duration = max_duration

func _on_sub_action_completed(boss: Node):
	completed_actions += 1
	if completed_actions >= sub_actions.size():
		completed.emit(boss)
