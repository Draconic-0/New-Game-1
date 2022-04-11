extends Button

var networker = null
var ip_entry = null

func _ready():
	ip_entry = get_node("/root/MainScene/network_panel/ip_entry")
	networker = get_node("/root/MainScene/networker")

func _pressed():
	print("connect to server!")
	networker.connect_to_server(ip_entry.text)
