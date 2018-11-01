extends Panel

signal disconnected

var ready_players = []

func _ready():
	pass

# Add a player to the ItemList
func add_player(playerName):
	for i in range($PlayerList.get_item_count()):
		if playerName == $PlayerList.get_item_text(i):
			return
	
	$PlayerList.add_item(playerName, null, true)
	$PlayersLabel.text = "Players: " + str(globals.players.size()) + "/8"

func update_number_of_players():
	$PlayersLabel.text = "Players: " + str(globals.players.size()) + "/8"

# When the start game button is pressed, the host will assign player numbers (to decide player order) and send that info to all other players
func _on_StartButton_pressed():
	for i in range(globals.players.size()):
		globals.players[i].player_number = i+1
	
	# Send all the other players the player numbers
	for i in range(globals.players.size()):
			for j in range(globals.players.size()):
				if globals.players[i].network_id != 1:
					rpc_id(globals.players[i].network_id, "set_player_number", globals.players[j].player_number, globals.players[j].player_name)
		

# Set the player number for a certain player
remote func set_player_number(num, name):
	for player in globals.players:
		if player.player_name == name:
			print("Setting player number " + str(num) + " for player " + player.player_name)
			player.player_number = num
	
	pre_config_game()

# When the Exit Game button is pressed, disconnect from the server.
func _on_ExitGame_pressed():
	if get_tree().is_network_server():
		for player in globals.players:
			if player.network_id != 1:
				get_tree().disconnect_network_peer(player.network_id)
				rpc_id(player.newtork_id, "disconnect_lobby")
		
	get_tree().set_network_peer(null)
	emit_signal("disconnected")

remote func disconnect_lobby():
	print("Disconnected from the lobby")
	get_tree().set_network_peer(null)
	emit_signal("disconnected")
	
func pre_config_game():
	
	rpc_id(1, "done_preconfig", get_tree().get_network_unique_id())
	
remote func done_preconfig(id):
	self.ready_players.append(id)
	
	if self.ready_players.size() == globals.players.size()-1:
		# Configure server game here
		pass