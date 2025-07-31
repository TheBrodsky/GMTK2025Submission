class_name InputRecording;

var recording: Dictionary[int, InputSnapshot]= {}; # key=framecount
var latest_frame_count: int = 0; # the latest frame a recording has been put into

func append(frame: int, value: InputSnapshot) -> void:
	# the very first frame should always be added
	if frame == 0:
		latest_frame_count = frame;
		recording.set(frame, value);
		return;
	
	# get latest input and compare with current input, if not equal, add new input
	var latest_input = recording.get(latest_frame_count);
	if latest_input:
		var input: InputSnapshot = latest_input;
		if input.is_equal(value):
			return;
	
	latest_frame_count = frame;
	recording.set(frame, value);
