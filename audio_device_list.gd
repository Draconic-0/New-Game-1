extends ItemList


var selected_audio_device = 0


func _ready():
	allow_reselect = true
	update_available_devices()

func mark_item(id):
	if get_item_text(id).substr(0,3)  != "=> ":
		set_item_text(id, "=> "+get_item_text(id))

func unmark_item(id):
	if get_item_text(id).substr(0,3) == "=> ":
		set_item_text(id, get_item_text(id).substr(3))

func update_available_devices():
	delete_all_items()
	
	var devices = AudioServer.get_device_list()
	for d in devices:
		add_item(d)


func delete_all_items():
	var item_count = get_item_count()
	for i in range(item_count):
		remove_item(i)


func _on_audio_device_list_item_selected(index):
	if selected_audio_device != index:
		unmark_item(selected_audio_device)
		selected_audio_device = index
		mark_item(selected_audio_device)
		AudioServer.set_device(AudioServer.get_device_list()[index])
