extends Node

var rooms = [
	"res://scenes/room_1.tscn",
	"res://scenes/room_2.tscn",
	"res://scenes/room_3.tscn",
	"res://scenes/room_4.tscn",
	"res://scenes/room_5.tscn",
	"res://scenes/room_6.tscn",
]

var current_room_index = 0
var current_room_instance = null
var room_container: Node = null

func start_run():
	rooms.shuffle()
	current_room_index = 0
	load_room(current_room_index)

func go_to_next_room():
	var main = get_tree().get_root().get_node_or_null("Main")
	if main == null:
		return
	var fade_rect = main.get_node_or_null("HUD/FadeRect")
	if fade_rect == null:
		return

	# Reset any room-specific state
	GameManager.reset_room_state()

	var tween_out = main.create_tween()
	tween_out.tween_property(fade_rect, "color:a", 1.0, 0.4)
	await tween_out.finished

	current_room_index += 1
	if current_room_index >= rooms.size():
		print("Run complete!")
		var tween_in = main.create_tween()
		tween_in.tween_property(fade_rect, "color:a", 0.0, 0.4)
		return

	await load_room(current_room_index)

	main.get_node("Player").global_position = Vector2(240, 400)
	main.get_node("Her").global_position = Vector2(280, 400)

	var tween_in = main.create_tween()
	tween_in.tween_property(fade_rect, "color:a", 0.0, 0.4)
	await tween_in.finished

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
