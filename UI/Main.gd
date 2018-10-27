extends Node

func _ready():
	$ConnectPanel.hide()
	$JoinPanel.hide()


func _on_MainMenu_connect_menu():
	$MainMenu.hide()
	$ConnectPanel.show()


func _on_ConnectPanel_join_button():
	$MainMenu.hide()
	$JoinPanel.show()


func _on_ConnectPanel_return_button():
	$ConnectPanel.hide()
	$MainMenu.show()


func _on_JoinPanel_return_button():
	$JoinPanel.hide()
	$ConnectPanel.show()
