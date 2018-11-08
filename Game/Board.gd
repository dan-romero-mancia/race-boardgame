extends Node

const TILE_SIZE = 128
const MAX_TILES = 16
const RACER_SIZE = 32

enum RACER {
	blue,
	green,
	orange,
	yellow,
	white
}

# Variable for each betting card
var blue_bet_five
var blue_bet_three
var blue_bet_two

var green_bet_five
var green_bet_three
var green_bet_two

var orange_bet_five
var orange_bet_three
var orange_bet_two

var yellow_bet_five
var yellow_bet_three
var yellow_bet_two

var white_bet_five
var white_bet_three
var white_bet_two

# List for each betting card pile
var blue_bet_pile = []
var green_bet_pile = []
var orange_bet_pile = []
var yellow_bet_pile = []
var white_bet_pile = []

# List of dice that can be rolled, there is one dice for each racer (color)
var dice

var my_turn = false
var player_turn_index = 0 # Used by the server machine to keep track of turns.

var racer_positions = []
var track_tiles = []

func _ready():
	# Initialize betting cards
	var BettingCard = load("res://Game/Classes/BettingCard.gd")
	blue_bet_five = BettingCard.new()
	blue_bet_five.init_card(globals.RACER.blue, 5)
	blue_bet_three = BettingCard.new()
	blue_bet_three.init_card(globals.RACER.blue, 3)
	blue_bet_two = BettingCard.new()
	blue_bet_two.init_card(globals.RACER.blue, 2)
	blue_bet_pile = [blue_bet_five, blue_bet_three, blue_bet_two]
	
	green_bet_five = BettingCard.new()
	green_bet_five.init_card(globals.RACER.green, 5)
	green_bet_three = BettingCard.new()
	green_bet_three.init_card(globals.RACER.green, 3)
	green_bet_two = BettingCard.new()
	green_bet_two.init_card(globals.RACER.green, 2)
	green_bet_pile = [green_bet_five, green_bet_three, green_bet_two]
	
	orange_bet_five = BettingCard.new()
	orange_bet_five.init_card(globals.RACER.orange, 5)
	orange_bet_three = BettingCard.new()
	orange_bet_three.init_card(globals.RACER.orange, 3)
	orange_bet_two = BettingCard.new()
	orange_bet_two.init_card(globals.RACER.orange, 2)
	orange_bet_pile = [orange_bet_five, orange_bet_three, orange_bet_two]
	
	yellow_bet_five = BettingCard.new()
	yellow_bet_five.init_card(globals.RACER.yellow, 5)
	yellow_bet_three = BettingCard.new()
	yellow_bet_three.init_card(globals.RACER.yellow, 3)
	yellow_bet_two = BettingCard.new()
	yellow_bet_two.init_card(globals.RACER.yellow, 2)
	yellow_bet_pile = [yellow_bet_five, yellow_bet_three, yellow_bet_two]
	
	white_bet_five = BettingCard.new()
	white_bet_five.init_card(globals.RACER.white, 5)
	white_bet_three = BettingCard.new()
	white_bet_three.init_card(globals.RACER.white, 3)
	white_bet_two = BettingCard.new()
	white_bet_two.init_card(globals.RACER.white, 2)
	white_bet_pile = [white_bet_five, white_bet_three, white_bet_two]

	# Initialize Betting card labels
	$BlueSprite/BlueWinningLabel.text = "1st Place: $5"
	$BlueSprite/BlueSecondLabel.text = "2nd Place: $1"
	$BlueSprite/BlueBottomLabel.text = "Other: -$1"

	$GreenSprite/GreenWinningLabel.text = "1st Place: $5"
	$GreenSprite/GreenSecondLabel.text = "2nd Place: $1"
	$GreenSprite/GreenBottomLabel.text = "Other: -$1"
	
	$OrangeSprite/OrangeWinningLabel.text = "1st Place: $5"
	$OrangeSprite/OrangeSecondLabel.text = "2nd Place: $1"
	$OrangeSprite/OrangeBottomLabel.text = "Other: -$1"
	
	$YellowSprite/YellowWinningLabel.text = "1st Place: $5"
	$YellowSprite/YellowSecondLabel.text = "2nd Place: $1"
	$YellowSprite/YellowBottomLabel.text = "Other: -$1"
	
	$WhiteSprite/WhiteWinningLabel.text = "1st Place: $5"
	$WhiteSprite/WhiteSecondLabel.text = "2nd Place: $1"
	$WhiteSprite/WhiteBottomLabel.text = "Other: -$1"
	
	# Initialize list for dice
	self.dice = [RACER.blue, RACER.green, RACER.orange, RACER.yellow, RACER.white]
	self.racer_positions = [1, 1, 1, 1, 1]
	
	for i in range(16):
		self.track_tiles.append([])

func _on_BlueBettingButton_pressed():
	if my_turn:
		var my_player = globals.get_player(globals.player_name)
		var betting_card = self.blue_bet_pile[0]
		my_player.betting_cards.append(self.blue_bet_pile[0])
		self.blue_bet_pile.pop_front()
		if blue_bet_pile.size() > 0:
			$BlueSprite/BlueWinningLabel.text = "1st Place: $" + str(blue_bet_pile[0].amount)
		else:
			$BlueSprite/BlueBettingButton.disabled = true
		
		signal_betting_card_taken(betting_card)
		add_message("You took a Blue betting card")
		
		my_turn = false
		send_next_player_turn()

func _on_GreenBettingButton_pressed():
	if my_turn:
		var my_player = globals.get_player(globals.player_name)
		var betting_card = self.green_bet_pile[0]
		my_player.betting_cards.append(self.green_bet_pile[0])
		self.green_bet_pile.pop_front()
		if green_bet_pile.size() > 0:
			$GreenSprite/GreenWinningLabel.text = "1st Place: $" + str(green_bet_pile[0].amount)
		else:
			$GreenSprite/GreenBettingButton.disabled = true
			
		signal_betting_card_taken(betting_card)
		add_message("You took a Green betting card")
		
		my_turn = false
		send_next_player_turn()

func _on_OrangeBettingButton_pressed():
	if my_turn:
		var my_player = globals.get_player(globals.player_name)
		var betting_card = self.orange_bet_pile[0]
		my_player.betting_cards.append(self.orange_bet_pile[0])
		self.orange_bet_pile.pop_front()
		if orange_bet_pile.size() > 0:
			$OrangeSprite/OrangeWinningLabel.text = "1st Place: $" + str(orange_bet_pile[0].amount)
		else:
			$OrangeSprite/OrangeBettingButton.disabled = true
			
		signal_betting_card_taken(betting_card)
		add_message("You took a Orange betting card")
		
		my_turn = false
		send_next_player_turn()

func _on_YellowBettingButton_pressed():
	if my_turn:
		var my_player = globals.get_player(globals.player_name)
		var betting_card = self.yellow_bet_pile[0]
		my_player.betting_cards.append(self.yellow_bet_pile[0])
		self.yellow_bet_pile.pop_front()
		if yellow_bet_pile.size() > 0:
			$YellowSprite/YellowWinningLabel.text = "1st Place: $" + str(yellow_bet_pile[0].amount)
		else:
			$YellowSprite/YellowBettingButton.disabled = true
			
		signal_betting_card_taken(betting_card)
		add_message("You took a Yellow betting card")
		
		my_turn = false
		send_next_player_turn()

func _on_WhiteBettingButton_pressed():
	if my_turn:
		var my_player = globals.get_player(globals.player_name)
		var betting_card = self.yellow_bet_pile[0]
		my_player.betting_cards.append(self.white_bet_pile[0])
		self.white_bet_pile.pop_front()
		if white_bet_pile.size() > 0:
			$WhiteSprite/WhiteWinningLabel.text = "1st Place: $" + str(white_bet_pile[0].amount)
		else:
			$YWhiteSprite/WhiteBettingButton.disabled = true
			
		signal_betting_card_taken(betting_card)
		add_message("You took a White betting card")
		
		my_turn = false
		send_next_player_turn()

# Signal to the other players that a betting card is taken via RPC
func signal_betting_card_taken(card):
	for p in globals.players:
		if p.player_name != globals.player_name:
			rpc_id(p.network_id, "set_betting_card_to_player", card.color, globals.player_name)

# Set a betting card to player
remote func set_betting_card_to_player(color, player_name):
	var player = globals.get_player(player_name)
	var card
	
	match color:
		RACER.blue:
			card = blue_bet_pile.pop_front()
			player.betting_cards.append(card)
			if blue_bet_pile.size() > 0:
				$BlueSprite/BlueWinningLabel.text = "1st Place: $" + str(blue_bet_pile[0].amount)
			else:
				$BlueSprite/BlueBettingButton.disabled = true
			add_message(player_name + " took the $" + str(card.amount) + " Blue betting card")
		RACER.green:
			card = green_bet_pile.pop_front()
			player.betting_cards.append(card)
			if green_bet_pile.size() > 0:
				$GreenSprite/GreenWinningLabel.text = "1st Place: $" + str(green_bet_pile[0].amount)
			else:
				$GreenSprite/GreenBettingButton.disabled = true
			add_message(player_name + " took the $" + str(card.amount) + " Green betting card")
		RACER.orange:
			card = orange_bet_pile.pop_front()
			player.betting_cards.append(card)
			if orange_bet_pile.size() > 0:
				$OrangeSprite/OrangeWinningLabel.text = "1st Place: $" + str(orange_bet_pile[0].amount)
			else:
				$OrangeSprite/OrangeBettingButton.disabled = true
			add_message(player_name + " took the $" + str(card.amount) + " Orange betting card")
		RACER.yellow:
			card = yellow_bet_pile.pop_front()
			player.betting_cards.append(card)
			if yellow_bet_pile.size() > 0:
				$YellowSprite/YellowWinningLabel.text = "1st Place: $" + str(yellow_bet_pile[0].amount)
			else:
				$YellowSprite/YellowBettingButton.disabled = true
			add_message(player_name + " took the $" + str(card.amount) + " Yellow betting card")
		RACER.white:
			card = white_bet_pile.pop_front()
			player.betting_cards.append(card)
			if white_bet_pile.size() > 0:
				$WhiteSprite/WhiteWinningLabel.text = "1st Place: $" + str(white_bet_pile[0].amount)
			else:
				$WhiteSprite/WhiteBettingButton.disabled = true
			add_message(player_name + " took the $" + str(card.amount) + " White betting card")
	

# Add a message to the message itemlist
func add_message(text):
	$MessageScrollBar/MessageList.add_item(text, null, true)

# When the move button is pressed; add 1 to your move cards and move a racer to a new location
# The racer is chosen randomly and is moved 1-3 spaces randomly
func _on_MoveButton_pressed():
	if my_turn:
		var player = globals.get_player(globals.player_name)
		player.move_cards += 1
		signal_move_card_taken(player.player_name)
		
		# Randomly determine which racer to move
		var random_racer = 0
		if self.dice.size() > 1:
			randomize()
			random_racer = int(floor(rand_range(1, 6)))
			while not random_racer in dice:
				randomize()
				random_racer = int(floor(rand_range(1, 6)))
		else:
			random_racer = dice.pop_front()
		
		dice.erase(random_racer)
		var spaces_moved = move_racer(random_racer, -1)
		
		if dice.size() == 0:
			pass ## End of leg here
		my_turn = false
		# Signal to other players that a racer has been moved
		signal_racer_moved(random_racer, spaces_moved)
		send_next_player_turn()

# Move a racer a certain amount of spaces
# If spaces_optional == -1, then get a random number from 1-3 and that will be the amount of spaces to move a racer
remote func move_racer(random_racer, spaces_optional):
	var spaces = spaces_optional
	
	if spaces_optional == -1:
		randomize()
		spaces = floor(rand_range(1, 4))
	else:
		dice.erase(random_racer)
	
	var racer_text
	match int(random_racer):
		RACER.blue:
			racer_text = "blue"
		RACER.green:
			racer_text = "green"
		RACER.orange:
			racer_text = "orange"
		RACER.yellow:
			racer_text = "yellow"
		RACER.white:
			racer_text = "white"
	
	var racers_to_move = get_racers_on_tile(self.racer_positions[random_racer], random_racer)
	if self.racer_positions[random_racer] == 1 or racers_to_move.size() == 1 :
		self.racer_positions[random_racer] += spaces
		racers_to_move = [random_racer]
	else:
		# Move the random racer and all racers on top of it
		for r in racers_to_move:
			self.racer_positions[r] += spaces
	
	animate_movement(racers_to_move, self.racer_positions[random_racer])
	## Check for Desert tiles here ##
	
	for r in racers_to_move:
		self.track_tiles[self.racer_positions[r]].append(r)
	
	if self.racer_positions[random_racer] > 16:
		pass # Racer wins here, start ending phase
	
	add_message(racer_text.capitalize() + " moved " + str(spaces) + " space(s)")
	return spaces

# Animate the movement of a racer from a tile to another
# If another racer is already on the destination tile, then stack the new ones on top
# Uses a Tween node to animate the movement
func animate_movement(racers, dest_space):
	var tile = get_node("Space" + str(dest_space))
	var tile_position = tile.position
	var tween = get_node("Tween")
	var new_racer_pos
	
	for r in racers:
		# Get the current racer's color as text. Will be used to get the correct racer sprite
		var racer_color = ""
		match int(r):
			RACER.blue:
				racer_color = "Blue"
			RACER.green:
				racer_color = "Green"
			RACER.orange:
				racer_color = "Orange"
			RACER.yellow:
				racer_color = "Yellow"
			RACER.white:
				racer_color = "White"
		
		var racer_name = racer_color + "Racer"
		var racer_sprite = get_node(racer_name)
		var new_x_pos = float(tile_position.x)
		var new_y_pos = float(tile_position.y) + RACER_SIZE - (RACER_SIZE * track_tiles[dest_space].size())
		var new_racer_position = Vector2(new_x_pos, new_y_pos)
		tween.interpolate_property(racer_sprite, "position", racer_sprite.position, new_racer_position, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		tween.start()

# Get the racer on a tile and any racers that are on top of it in one array
func get_racers_on_tile(tile_number, racer_color):
	var racers = self.track_tiles[tile_number]
	var racer_index = racers.find(racer_color)
	
	# If the racer is last in the array, it is at the top, it can be returned in a list with just itself
	if racer_index == racers.size()-1:
		return [track_tiles.pop_back()]
	# Otherwise return a list with the racer and all other racers on top of it
	else:
		var racers_to_move = []
		for i in range(racer_index, track_tiles.size()):
			racers_to_move.append(racers[i])
			racers.erase(racers[i])
			
		return racers_to_move

# Signal to the other players that a racer has been moved
func signal_racer_moved(racer, spaces_moved):
	for p in globals.players:
		if p.player_name != globals.player_name:
			rpc_id(p.network_id, "move_racer", racer, spaces_moved)

# Determine the next player in the turn order and send that info to the other players
func send_next_player_turn():
	self.player_turn_index = globals.get_player_index(globals.player_name)+1
	if self.player_turn_index == globals.players.size():
		self.player_turn_index = 0
	
	# Add message in message list
	if globals.players[player_turn_index].player_name == globals.player_name:
		add_message("It's your turn now!")
	else:
		add_message("It's " + globals.players[player_turn_index].player_name + " turn now!")
	
	# Send new player's turn to all players
	for p in globals.players:
		if p.player_name != globals.player_name:
			rpc_id(p.network_id, "set_player_turn", self.player_turn_index)

# Determine if it is the current machine's turn
remote func set_player_turn(index):
	self.my_turn = globals.players[index].player_name == globals.player_name
	if self.my_turn:
		add_message("It's your turn now!")
	else:
		add_message("It's " + globals.players[index].player_name + " turn now!")

# Update the number of move cards that a player has gathered
remote func update_player_move_cards(player_name):
	globals.get_player(player_name).move_cards += 1

# Signal to the other players that a move card has been taken
func signal_move_card_taken(player_name):
	for p in globals.players:
		if p.player_name != globals.player_name:
			rpc_id(p.network_id, "update_player_move_cards", player_name)