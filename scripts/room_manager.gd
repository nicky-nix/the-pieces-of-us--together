extends Node

var rooms = [
	"res://scenes/room_1.tscn",
	"res://scenes/room_2.tscn",
	"res://scenes/room_3.tscn",
	"res://scenes/room_4.tscn",
	"res://scenes/room_5.tscn",
	"res://scenes/room_6.tscn",
	"res://scenes/room_7.tscn",  # light puzzle
	"res://scenes/room_8.tscn", 
]

var current_room_index = 0
var current_room_instance = null
var room_container: Node = null
var is_transitioning = false

func start_run():
	rooms.shuffle()
	current_room_index = 0
	is_transitioning = false
	load_room(current_room_index)

func go_to_next_room():
	# Prevent double triggering
	if is_transitioning:
		return
	is_transitioning = true
	print("=== Going to next room ===")
	_do_transition()

func _do_transition():
	var main = get_tree().get_root().get_node_or_null("Main")
	if main == null:
		print("ERROR: Main not found")
		return

	var fade_rect = main.get_node_or_null("HUD/FadeRect")
	if fade_rect == null:
		print("ERROR: FadeRect not found")
		return

	# Fade out
	var tween_out = main.create_tween()
	tween_out.tween_property(fade_rect, "color:a", 1.0, 0.4)
	await tween_out.finished
	
	main.player.stop()
	main.her.stop()
		
		# Then move them to start position
	main.player.global_position = Vector2(240, 400)
	main.her.global_position = Vector2(280, 400)
		
		# Set nav targets to their new positions so they don't walk away
	main.player.get_node("NavigationAgent2D").target_position = main.player.global_position
	main.her.get_node("NavigationAgent2D").target_position = main.her.global_position
	# Next room
	current_room_index += 1
	if current_room_index >= rooms.size():
		# Stay faded to black, then switch scene
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/epilogue.tscn")
		return

	await load_room(current_room_index)

	# Move players to start
	main.get_node("Player").global_position = Vector2(240, 400)
	main.get_node("Her").global_position = Vector2(280, 400)

	# Fade in
	var tween_in = main.create_tween()
	tween_in.tween_property(fade_rect, "color:a", 0.0, 0.4)
	await tween_in.finished
	is_transitioning = false

func load_room(index):
	# Free old room
	if current_room_instance != null:
		current_room_instance.queue_free()
		await current_room_instance.tree_exited

	# Load new room
	var room_scene = load(rooms[index])
	current_room_instance = room_scene.instantiate()
	room_container.add_child(current_room_instance)
	print("Room loaded: ", rooms[index])

	# Find and connect ExitDoor
	_connect_exit(current_room_instance)

func _connect_exit(room):
	# Search for ExitDoor anywhere in the room tree
	var exit = _find_node(room, "ExitDoor")
	if exit == null:
		print("WARNING: No ExitDoor found in room")
		return
	if exit.exit_reached.is_connected(go_to_next_room):
		return
	exit.exit_reached.connect(go_to_next_room)
	print("ExitDoor connected in: ", room.name)

func _find_node(node: Node, target_name: String) -> Node:
	if node == null:
		return null
	if node.name == target_name:
		return node
	for child in node.get_children():
		if child == null:
			continue
		var result = _find_node(child, target_name)
		if result != null:
			return result
	return null
	
	
