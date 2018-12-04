extends PopupMenu

signal color_chosen(color)

func _ready():
	var color_index = 0
	for button in get_tree().get_nodes_in_group("ColorButtons"):
		button.connect("pressed", self, "_Color_button_selected", [color_index])
		color_index += 1

func set_title_label(title):
	$VBoxContainer/TitleLabel.text += title
	
func _Color_button_selected(color):
	emit_signal("color_chosen", color)
	self.hide()

func _on_CancelButton_pressed():
	self.hide()
