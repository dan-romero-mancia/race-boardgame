extends Panel

signal connect_button
signal return_button

func _ready():
	pass

func _on_CreateButton_pressed(): 
	if $NameEdit.get_line(0).length() <= 0:
		$MessageLabel.text = "Please enter a name"
		return

	globals.player_name = $NameEdit.get_line(0)
	globals.init_server_player(globals.player_name)
	emit_signal("connect_button")

func _on_ReturnButton_pressed():
	emit_signal("return_button")
	

