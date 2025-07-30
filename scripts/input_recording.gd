class_name InputRecording;

var recording: Array[InputSnapshot] = [];

func append(value: InputSnapshot) -> void:
	recording.append(value); # todo: Do not append duplicates.
