class_name DebugPrintAction extends AtomicBossAction

var print_time_accumulator: float = 0.0

func _perform_action(delta: float):
	print_time_accumulator += delta
	
	if print_time_accumulator >= 1.0:
		print_time_accumulator -= 1.0
		var elapsed = duration - timer.time_left
		var progress = elapsed / duration * 100.0
		print(name, " - Progress: ", "%.1f" % progress, "% (", "%.1f" % elapsed, "s / ", duration, "s)")
