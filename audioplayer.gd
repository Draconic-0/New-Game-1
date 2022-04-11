extends AudioStreamPlayer




func _on_increase_vol_button_pressed():
	var idx = AudioServer.get_bus_index("Master")
	var effect = AudioServer.get_bus_effect(idx, 0)
	effect.volume_db += 1


func _on_decrease_vol_button_pressed():
	var idx = AudioServer.get_bus_index("Master")
	var effect = AudioServer.get_bus_effect(idx, 0)
	effect.volume_db -= 1
