# Class for Player object, holds player info like name, player number, and id.

var player_name
var player_number
var network_id

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
