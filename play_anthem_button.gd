extends Button

var playback = null
var anthem_stream = preload("res://audio/hymne.mp3")
var audioplayer = null

var sample_hz = 22050.0
var pulse_hz = 440.0
var phase = 0.0



func _ready():
	audioplayer = get_node("/root/MainScene/audioplayer")
	audioplayer.stream = AudioStreamGenerator.new()
	audioplayer.stream.mix_rate  = sample_hz
	



func _fill_buffer():
	var increment = pulse_hz / sample_hz

	var to_fill = playback.get_frames_available()
	while to_fill > 0:
		playback.push_frame(Vector2.ONE * sin(phase * TAU)) # Audio frames are stereo.
		phase = fmod(phase + increment, 1.0)
		to_fill -= 1


func _pressed():
	playback = audioplayer.get_stream_playback()
	_fill_buffer()
	audioplayer.play()
