extends Button


var networker = null
var msg_entry = null

func _ready():
	msg_entry = get_node("/root/MainScene/chat_panel/msg_entry")
	networker = get_node("/root/MainScene/networker")

func _pressed():
	var txt = msg_entry.text
	networker.write_message(txt)
	msg_entry.text = ""
