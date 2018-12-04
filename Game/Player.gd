extends Container

var player_name = ""

func _ready():
	$MoneyLabel.text = "$0"
	$PlayerLabel.text = player_name

func set_player_name(name):
	self.player_name = name
	$PlayerLabel.text = name

func set_money_amount(amount):
	$MoneyLabel.text = "$" + str(amount)

func set_player_number(number):
	$NumberLabel.text = "Player " + str(number)

func set_leg_starter(on):
	if on:
		$LegStarterSprite.show()
	else:
		$LegStarterSprite.hide()