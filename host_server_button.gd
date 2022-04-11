extends Button

var networker = null

func _ready():
	networker = get_node("/root/MainScene/networker")

func _pressed():
	print("host server!")
	networker.host_server()
