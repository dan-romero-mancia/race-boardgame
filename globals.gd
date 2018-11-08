#Contains Global variables and constants.

extends Node

const PORT = 4242

enum RACER {
	blue,
	green,
	orange,
	yellow,
	white
}

var players = []
var player_name = ""

# Add a new Player object to the list of players
func add_player(id, name):
	var Player = load("res://Game/Classes/Player.gd")
	var new_player = Player.new()
	new_player.init_player(id, name, -1)
	players.append(new_player) 
	
# Initalize the server player (Always has network_id and player number of 1)
func init_server_player(name):
	var Player = load("res://Game/Classes/Player.gd")
	var new_player = Player.new()
	new_player.init_player(1, name, 1)
	players.append(new_player)
	
# Remove a player object from the list of players
func remove_player(id):
	var removed_player = null
	for player in players:
		if player.network_id == id:
			removed_player = player
	
	players.erase(removed_player)
	
func get_player(name):
	for p in players:
		if p.player_name == name:
			return p
			
func get_player_index(player_name):
	for i in range(players.size()):
		if player_name == players[i].player_name:
			return i
