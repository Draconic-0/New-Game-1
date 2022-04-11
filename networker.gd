extends Node

const SERVER_PORT = 33333

var is_hosting = false
var is_client = false

var chat = null

var playback = null
var audioplayer = null
var audiobuffer = []

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	#setup audioplayer
	
	if audioplayer == null:
		audioplayer = get_node("/root/MainScene/audioplayer")
		#audioplayer.stream = AudioStreamGenerator.new()
		audioplayer.stream.mix_rate  = 11025
		playback = audioplayer.get_stream_playback()
		audioplayer.play()
	


func _player_connected(id):
	print("player connected")

func _player_disconnected(id):
	print("player disconnected")

func _connected_ok():
	print("connected ok")

func _server_disconnected():
	print("server disconnected")

func _fill_buffer():
	var buffer = []
	
	var increment = 440 / 22050
	
	var phase = 0
	var to_fill = playback.get_frames_available()
	while to_fill > 0:
		var new_frame = Vector2.ONE * sin(phase * TAU)
		buffer.append(new_frame)
		#playback.push_frame(new_frame) # Audio frames are stereo.
		phase = fmod(phase + increment, 1.0)
		to_fill -= 1
	return buffer

func _process(_delta):
	playback = audioplayer.get_stream_playback()
	
#	if playback.get_frames_available() < 1:
#		return
#
#	for i in range(min(playback.get_frames_available(), audiobuffer.size())):
#		playback.push_frame(audiobuffer[0])
#		audiobuffer.remove(0)
#
#	if playback.get_frames_available() > 0:
#		var buffer = PoolVector2Array()
#		buffer.resize(playback.get_frames_available())
#		playback.push_buffer(buffer)


func host_server():
	is_client = false
	if get_tree().network_peer != null:
		get_tree().network_peer.close_connection()
		
	if not is_hosting:
		is_hosting = true
		var peer = NetworkedMultiplayerENet.new()
		peer.set_bind_ip("0.0.0.0")
		peer.create_server(33333, 5)
		get_tree().network_peer = peer


func connect_to_server(server_ip):
	is_hosting = false
	
	if get_tree().network_peer != null:
		get_tree().network_peer.close_connection()
	
	is_client = true
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(server_ip, SERVER_PORT)
	get_tree().network_peer = peer

remotesync func add_message(msg):
	chat.text += msg+"\n"


func write_audio_chunk(data):
	rpc_unreliable("_send_audio_chunk", data)

remote func _send_audio_chunk(data):
	playback.push_buffer(data)
	

func write_message(msg):
	rpc("add_message", msg)
