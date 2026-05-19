extends Node

var active_player = "you"
var has_key = false
var memory_stones_found = 0
var collected_memories: Array = []   # stores item IDs like ["flower", "book"]

func switch_character():
	if active_player == "you":
		active_player = "her"
	else:
		active_player = "you"

func reset_room_state():
	has_key = false
	
func reset_run_state():
	has_key = false
	memory_stones_found = 0
	collected_memories = []
