extends Node

var audio_capture = null
var muted = false
var networker

var c = 0


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
	#mic.stream.mix_rate = 22050.0
	mic.bus = AudioServer.get_bus_name(idx)
	add_child(mic)
	mic.play()



func _process(delta):
	if muted == false:
		var frames = audio_capture.get_frames_available()
		var buffer = audio_capture.get_buffer(frames)
		var new_buffer = []
		
		for i in range(len(buffer)):
			if i % 4 == 0:
				new_buffer.append(buffer[i])
		networker.write_audio_chunk(new_buffer)
		
		
