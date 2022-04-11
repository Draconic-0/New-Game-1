extends Button

var playback = null
var anthem_stream = preload("res://audio/hymne.mp3")
var audioplayer = null

var sample_hz = 22050.0
var pulse_hz = 440.0
var phase = 0.0

var networker

func _ready():
	networker = get_node("/root/MainScene/networker")
	
	audioplayer = get_node("/root/MainScene/audioplayer")
	#audioplayer.stream = AudioStreamGenerator.new()
	#audioplayer.stream.mix_rate  = sample_hz
	#playback = audioplayer.get_stream_playback()
	#audioplayer.play()
	



func _fill_buffer():
	var buffer = []
	
	var increment = pulse_hz / sample_hz

	var to_fill = playback.get_frames_available()
	while to_fill > 0:
		var new_frame = Vector2.ONE * sin(phase * TAU)
		buffer.append(new_frame)
		#playback.push_frame(new_frame) # Audio frames are stereo.
		phase = fmod(phase + increment, 1.0)
		to_fill -= 1
	return buffer


func _pressed():
	
	var buffer = _fill_buffer()
	networker.write_audio_chunk(buffer)
	#playback.push_buffer(buffer)
	
