extends Node

var active_player = "you"

func switch_character():
	if active_player == "you":
		active_player = "her"
	else:
		active_player = "you"
