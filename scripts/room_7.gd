# room_7.gd
extends Node2D

func _ready():
	# Show room intro dialogue
	await get_tree().create_timer(0.6).timeout
	DialogueManager.show_dialogue("room_dark")

	# Wait for room_manager to finish connecting ExitDoor
	await get_tree().process_frame

	# Intercept the exit — disconnect room_manager, connect our own handler
	var exit = _find_exit(self)
	if exit == null:
		print("ERROR: ExitDoor not found in room_7")
		return
	if exit.exit_reached.is_connected(RoomManager.go_to_next_room):
		exit.exit_reached.disconnect(RoomManager.go_to_next_room)
	exit.exit_reached.connect(_on_exit_reached)

func _on_exit_reached():
	if GameManager.active_player == "her":
		RoomManager.go_to_next_room()
	else:
		# Wrong character — reset triggered so player can try again after switching
		var exit = _find_exit(self)
		if exit:
			exit.triggered = false
		if not DialogueManager.is_showing:
			DialogueManager.show_dialogue("room_dark_hint")

func _find_exit(node: Node) -> Node:
	if node.name == "ExitDoor":
		return node
	for child in node.get_children():
		var result = _find_exit(child)
		if result:
			return result
	return null
