# Class for Player object, holds player info like name, player number, and id.

var player_name
var player_number
var network_id
var money_amount = 0
var turn = false
var betting_cards = []
var move_cards = 0
var has_desert_tile = true

func init_player(id, name, number):
	network_id = id
	player_name = name
	player_number = number

func set_id(id):
	network_id = id

func set_player_name(name):
	player_name = name

func set_player_number(number):
	player_number = number

func add_money_amount(amount):
	self.money_amount += amount

# Reset the betting_cards and move_cards variables. Typically used when a leg of the race is finished.
func reset_leg():
	betting_cards = []
	move_cards = 0
	has_desert_tile = true