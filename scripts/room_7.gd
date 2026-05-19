# room_7.gd
extends Node2D

func _ready():
	# Exit is always active — the puzzle is navigating in the dark
	# No extra setup needed; ExitDoor works normally
	# Optional: show a hint when player (you) enters
	#$HintLabel.visible = true
	#await get_tree().create_timer(3.0).timeout
	#$HintLabel.visible = false
	await get_tree().create_timer(0.6).timeout
	DialogueManager.show_dialogue("room_attic")  # change ID per room
