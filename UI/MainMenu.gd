extends Panel

signal connect_menu

func _ready():

	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_ConnectButton_pressed():
	emit_signal("connect_menu")


func _on_QuitButton_pressed():
	get_tree().quit()
