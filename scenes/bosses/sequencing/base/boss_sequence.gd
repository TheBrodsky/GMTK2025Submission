## Actions that run one after another in sequence
## A boss' actions are defined by a sequence, which itself can include sequences.
class_name BossSequence extends BossAction

var actions: Array[BossAction] = []

func _ready():
	_get_actions()
	_calculate_duration()
	_chain_actions()

func execute(boss: Node):
	super.execute(boss)
	if actions.is_empty():
		push_error("Cannot execute sequence: no actions")
		return
	
	actions[0].execute(boss)

func _get_actions():
	actions.clear()
	for child in get_children():
		if child is BossAction:
			actions.append(child)

func _calculate_duration():
	var total_duration = 0.0
	for action in actions:
		total_duration += action.duration
	duration = total_duration

func _chain_actions():
	for i in range(actions.size() - 1):
		actions[i].completed.connect(actions[i + 1].execute)
	
	if actions.size() > 0:
		actions[-1].completed.connect(_on_sequence_complete)

func _on_sequence_complete(boss: Node):
	completed.emit(boss)
