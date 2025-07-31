class_name InputRecording;

var recording: Dictionary[int, InputSnapshot]= {}; # key=framecount

func append(frame: int, value: InputSnapshot) -> void:
	# todo: Do not insert duplicate values
	recording.set(frame, value);
