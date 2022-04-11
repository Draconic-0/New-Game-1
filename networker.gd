extends Node

const SERVER_PORT = 33333

var peer = null
var is_hosting = false
var is_client = false

var chat = null

func _ready():
	chat = get_node("/root/MainScene/chat_panel/chat")
	
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")


func _player_connected():
	print("player connected")

func _player_disconnected():
	print("player disconnected")

func _connected_ok():
	print("connected ok")

func _server_disconnected():
	print("server disconnected")



func host_server():
	is_client = false
	if peer != null and is_client:
		peer.close_connection()
		
	if not is_hosting:
		is_hosting = true
		peer = NetworkedMultiplayerENet.new()
		peer.create_server(33333, 5)
		get_tree().network_peer = peer


func connect_to_server(server_ip):
	is_hosting = false
	
	if peer != null and is_hosting:
		peer.close_connection()
	if not is_client:
		is_client = true
		peer = NetworkedMultiplayerENet.new()
		peer.create_client(server_ip, SERVER_PORT)
		get_tree().network_peer = peer

remotesync func add_message(msg):
	chat.text += msg+"\n"
	

func write_message(msg):
	if peer != null:
		rpc("add_message", msg)
		chat.text += msg+"\n"
