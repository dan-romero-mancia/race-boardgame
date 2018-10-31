extends Panel

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
