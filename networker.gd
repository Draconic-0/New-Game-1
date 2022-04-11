extends Node

const SERVER_PORT = 33333

var peer = null
var is_hosting = false
var is_client = false

var chat = null

func _ready():
	chat = get_node("/root/MainScene/chat_panel/chat")

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
