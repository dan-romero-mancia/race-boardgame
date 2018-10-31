extends Panel

var regex = RegEx.new()
signal return_button
signal connect_button

func _ready():
	regex.compile("\\A(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\z")

# When the join button is pressed, check if the IP address is a valid one and if there's text in NameEdit
func _on_JoinButton_pressed():
	if !check_if_ip($IPEdit.get_line(0)):
		$MessageLabel.text = "Not a valid IP Address"
		return
		
	if $NameEdit.get_line(0).length() <= 0:
		$MessageLabel.text = "Please enter a name"
		return
	
	globals.player_name = $NameEdit.get_line(0)
	emit_signal("connect_button")
	$JoinButton.disabled = true

# Check if a given IP address is valid if it matches a regular expression
func check_if_ip(text):
	var result = regex.search(text)
	return result != null

func _on_ReturnButton_pressed():
	emit_signal("return_button")

func display_error_popup():
	$ErrorDialog.popup_centered()
	$JoinButton.disabled = false

func _on_CloseDialogButton_pressed():
	$ErrorDialog.hide()
