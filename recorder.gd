extends Node

var audio_capture = null
var muted = false
var networker


func _ready():
	networker = get_node("/root/MainScene/networker")
	
	#var idx := AudioServer.get_bus_count()
	#AudioServer.add_bus(idx)
	#AudioServer.set_bus_mute(idx, true)
	#AudioServer.add_bus_effect(idx, audio_capture)
	#AudioServer.set_bus_send(idx, "deadend")
	
	var idx = AudioServer.get_bus_index("input")
	audio_capture = AudioServer.get_bus_effect(idx, 0)
	
	#AudioServer.set_bus_mute(idx, true)
	
	var mic := AudioStreamPlayer.new()
	mic.stream = AudioStreamMicrophone.new()
	mic.bus = AudioServer.get_bus_name(idx)
	add_child(mic)
	mic.play()


func mute():
	muted = true

func unmute():
	muted = false


func _process(delta):
	if muted == false:
		var frames = audio_capture.get_frames_available()
		var buffer = audio_capture.get_buffer(frames)
		if len(buffer) > 0:
			print(buffer[0])
		networker.write_audio_chunk(buffer)
		#networker.audio_playback.push_buffer(buffer)
