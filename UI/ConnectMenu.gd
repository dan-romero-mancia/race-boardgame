extends Panel

signal join_button
signal return_button
signal connect_button

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _on_JoinButton_pressed():
	emit_signal("join_button")

func _on_ReturnButton_pressed():
	emit_signal("return_button")

func _on_CreateButton_pressed():
	emit_signal("connect_button")
