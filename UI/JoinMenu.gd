extends Panel

var regex = RegEx.new()
signal return_button

func _ready():
	regex.compile("\\A(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\z")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_JoinButton_pressed():
	if !check_if_ip($IPEdit.get_line(0)):
		$MessageLabel.text = "Not a valid IP Address"
		return
	
	$MessageLabel.text = "Valid IP Address"
	
func check_if_ip(text):
	var result = regex.search(text)
	return result != null

func _on_ReturnButton_pressed():
	emit_signal("return_button")
