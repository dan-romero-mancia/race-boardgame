extends Node

func _ready():
	$ConnectPanel.hide()
	$JoinPanel.hide()
	$CreatePanel.hide()
	$LobbyPanel.hide()
	
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")

func _on_MainMenu_connect_menu():
	$MainMenu.hide()
	$ConnectPanel.show()

func _on_ConnectPanel_return_button():
	$ConnectPanel.hide()
	$MainMenu.show()

func _on_JoinPanel_return_button():
	$JoinPanel.hide()
	$ConnectPanel.show()

func _on_ConnectPanel_join_button():
	$ConnectPanel.hide()
	$JoinPanel.show()

func _on_ConnectPanel_connect_button():
	$ConnectPanel.hide()
	$CreatePanel.show()

func _on_CreatePanel_return_button():
	$CreatePanel.hide()
	$ConnectPanel.show()

func _player_connected(id):
	print("Player connected to server!")

# When the button is pressed, create a new server and transition into the lobby scene
func _on_CreatePanel_connect_button():
	print("Hosting Network")
	var host = NetworkedMultiplayerENet.new()
	var res = host.create_server(globals.PORT, 2)
	if res != OK:
		print("Error creating Server")
		return
	 
	get_tree().set_network_peer(host)
	#globals.add_player(get_tree().get_network_unique_id(), globals.player_name)
	
	$CreatePanel.hide() 
	$LobbyPanel.show()
	$LobbyPanel.add_player(globals.player_name)

# Connect to a server. Creates a network client.
func _on_JoinPanel_connect_button():
	print("Joining network")
	var host = NetworkedMultiplayerENet.new()
	host.create_client($JoinPanel/IPEdit.text, globals.PORT)
	get_tree().set_network_peer(host)
	
func _connected_fail():
	print("Connection failed")
	$JoinPanel.display_error_popup()

# Executed when the connection to a server is made and is OK.
func _connected_ok():
	print("Joined network")
	$JoinPanel.hide()
	$LobbyPanel.show()
	$LobbyPanel.add_player(globals.player_name)
	$LobbyPanel/StartButton.hide()
	globals.add_player(get_tree().get_network_unique_id(), globals.player_name)
	rpc("register_player", get_tree().get_network_unique_id(), globals.player_name)

# Register a new player with network ID and name. 
# If the machine that is executing this is the server, then send it's info and the other currently connected player's info to the newly registered player. 
remote func register_player(id, name):
	if get_tree().is_network_server():
		if is_lobby_full():
			rpc_id(id, "lobby_full_disconnect")
			get_tree().disconnect_network_peer(id)
			return
	
	globals.add_player(id, name)
	
	if get_tree().is_network_server():
		#Server will send it's info to newly connected player.
		rpc_id(id, "register_player", 1, globals.player_name)
		#Send info of other players in the server to the newly connected player
		for player in globals.players:
			if player.network_id != 1 && player.player_name != name:
				rpc_id(id, "register_player", player.network_id, player.player_name)
				rpc_id(player.network_id, "register_player", id, name)

	$LobbyPanel.add_player(name)
	
remote func lobby_full_disconnect():
	print("Lobby is full, cannot connect")
	
# Check if the lobby is full.
func is_lobby_full():
	if globals.players.size() >= 8:
		return true
	return false

func _on_LobbyPanel_disconnected():
	$LobbyPanel.hide()
	$ConnectPanel.show()
