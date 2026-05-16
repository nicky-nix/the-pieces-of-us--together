extends Node

var rooms = [
	"res://scenes/room_1.tscn",
	"res://scenes/room_2.tscn",
	"res://scenes/room_3.tscn",
]

var current_room_index = 0
var current_room_instance = null
var room_container: Node = null

func start_run():
	rooms.shuffle()
	current_room_index = 0
	load_room(current_room_index)

func go_to_next_room():
	print("=== go_to_next_room called ===")
	
	var main = get_tree().get_root().get_node_or_null("Main")
	print("Main node found: ", main)
	
	if main == null:
		print("ERROR: Main is null — check your root node is named exactly Main")
		return

	var fade_rect = main.get_node_or_null("HUD/FadeRect")
	print("FadeRect found: ", fade_rect)
	
	if fade_rect == null:
		print("ERROR: FadeRect is null — check HUD/FadeRect path")
		return

	print("Starting fade out...")
	var tween_out = main.create_tween()
	tween_out.tween_property(fade_rect, "color:a", 1.0, 0.4)
	await tween_out.finished
	print("Fade out done")

	current_room_index += 1
	if current_room_index >= rooms.size():
		print("Run complete!")
		var tween_in = main.create_tween()
		tween_in.tween_property(fade_rect, "color:a", 0.0, 0.4)
		return

	await load_room(current_room_index)

	main.get_node("Player").global_position = Vector2(240, 400)
	main.get_node("Her").global_position = Vector2(280, 400)

	print("Starting fade in...")
	var tween_in = main.create_tween()
	tween_in.tween_property(fade_rect, "color:a", 0.0, 0.4)
	await tween_in.finished
	print("Fade in done")

func load_room(index):
	if current_room_instance != null:
		current_room_instance.queue_free()
		await current_room_instance.tree_exited

	var room_scene = load(rooms[index])
	current_room_instance = room_scene.instantiate()
	room_container.add_child(current_room_instance)

	var exit = current_room_instance.get_node_or_null("ExitDoor")
	if exit == null:
		print("ERROR: ExitDoor not found in room — check node is named exactly ExitDoor")
		return
	exit.exit_reached.connect(go_to_next_room)
	print("Room loaded: ", rooms[index])
