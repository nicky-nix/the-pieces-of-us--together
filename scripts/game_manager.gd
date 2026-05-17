extends Node

var active_player = "you"
var has_key = false

func switch_character():
	if active_player == "you":
		active_player = "her"
	else:
		active_player = "you"

func reset_room_state():
	has_key = false
