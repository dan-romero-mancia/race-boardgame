extends Panel

signal disconnected

var ready_players = []
var total_set_players = 0 # The number of players that have their player number set

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
	var random_numbers = []
	var number = 0
	
	# Randomize player numbers
	for i in range(globals.players.size()):
		randomize()
		number = floor(rand_range(1, globals.players.size()+1))
		while number in random_numbers:
			randomize()
			number = floor(rand_range(1, globals.players.size()+1))

		random_numbers.append(number)
		globals.players[i].player_number = number
	
	# Send all the other players the player numbers
	for i in range(globals.players.size()):
		for j in range(globals.players.size()):
			if globals.players[i].network_id != 1:
				rpc_id(globals.players[i].network_id, "set_player_number", globals.players[j].player_number, globals.players[j].player_name)
	
	globals.players.sort_custom(self, "compare_player_number")
	globals.players[0].turn = true
	pre_config_game()

# Set the player number for a certain player
remote func set_player_number(num, name):
	for player in globals.players:
		if player.player_name == name:
			print("Setting player number " + str(num) + " for player " + player.player_name)
			player.player_number = num
			self.total_set_players += 1
	
	if self.total_set_players == globals.players.size():
		globals.players.sort_custom(self, "compare_player_number")
		pre_config_game()

# Custom comparison of Player objects 
func compare_player_number(a, b):
	if typeof(a) != typeof(b):
		return typeof(a) < typeof(b)
	else:
		return a.player_number < b.player_number

# When the Exit Game button is pressed, disconnect from the server.
func _on_ExitGame_pressed():
	if get_tree().is_network_server():
		for player in globals.players:
			if player.network_id != 1:
				get_tree().disconnect_network_peer(player.network_id)
				rpc_id(player.newtork_id, "disconnect_lobby")
		
	get_tree().set_network_peer(null)
	emit_signal("disconnected")

# Disconnect from the lobby
remote func disconnect_lobby():
	print("Disconnected from the lobby")
	get_tree().set_network_peer(null)
	emit_signal("disconnected")

# Pre configure the game. Pause the tree. Load the Board node. Player nodes will be loaded for each player in the game
# When finished configuring, send a signal to the server that this player has finished
func pre_config_game():
	get_tree().set_pause(true)
	var network_id = get_tree().get_network_unique_id()
	
	# Load world
	var board = load("res://Game/Board.tscn").instance()
	get_node("/root").add_child(board)
	
	var index = 0
	
	# Load Player nodes for the other players
	for p in globals.players:
		var player = preload("res://Game/Player.tscn").instance()
		player.set_name(str(p.network_id))
		get_node("/root/Board/Players").add_child(player)
		player.set_player_name(p.player_name)
		player.set_money_amount(3)
		player.set_player_number(p.player_number)
		player.set_leg_starter(false)
		
		set_player_position(player, index)
		index += 1
	
	if globals.players[0].player_name == globals.player_name:
		board.my_turn = true
	board.set_leg_player_turn_sprite(globals.players[0])
	# When finished notify the server.
	if !get_tree().is_network_server():
		rpc_id(1, "done_preconfig", get_tree().get_network_unique_id())

# Only the server executes this function
# The server keeps track of clients that have finished pre configuring.
# Once all clients are done, notify them to transition into post configuration
remote func done_preconfig(id):
	assert(get_tree().is_network_server())
	
	if not id in ready_players:
		self.ready_players.append(id)
		
		if self.ready_players.size() == globals.players.size()-1:
			for p in globals.players:
				if p.network_id != 1:
					rpc("post_config_game")
		post_config_game()

# Unpause the tree and remove the Main menu node from the tree.
remote func post_config_game():
	get_tree().set_pause(false)
	get_node("/root/Main").queue_free()

# Set the position and size of a newly created Player node
func set_player_position(player, index):
	player.rect_position = Vector2(player.rect_position.x, player.rect_position.y + 68*index+3)
	player.rect_size = Vector2(212, 68)