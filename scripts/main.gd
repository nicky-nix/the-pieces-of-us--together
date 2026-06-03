# main.gd
extends Node2D

@onready var camera       = $Camera2D
@onready var player       = $Player
@onready var her          = $Her
@onready var room_container = $RoomContainer
@onready var switch_button  = $HUD/SwitchButton
@onready var room_name_label = $HUD/RoomNameLabel
@onready var memory_counter  = $HUD/MemoryCounter

# Maps room scene filename to display name shown on screen
const ROOM_NAMES = {
	"room_1": "The Café",
	"room_2": "The Hilltop",
	"room_3": "The Library",
	"room_memory_1": "A Memory",
	"room_4": "The Hilltop",
	"room_5": "The Rainy Day",
	"room_memory_2": "A Memory",
	"room_6": "The Garden",
	"room_7": "The Dark Room",
	"room_8": "The Starfield",
	"room_memory_3": "A Memory",
}

func _ready():
	RoomManager.room_container = room_container
	RoomManager.start_run()
	player.z_index = 10
	her.z_index = 10
	camera.global_position = player.global_position
	$HUD/GalleryOverlay.visible = false
	room_name_label.modulate.a = 0.0
	_update_memory_counter()

	await get_tree().process_frame
	_move_players_to_start()

	# Show room name for first room
	_show_room_name(RoomManager.current_room_index)

func _move_players_to_start():
	player.global_position = Vector2(240, 400)
	her.global_position = Vector2(280, 400)
	player.get_node("NavigationAgent2D").target_position = player.global_position
	her.get_node("NavigationAgent2D").target_position = her.global_position

func _on_switch_button_pressed():
	if DialogueManager.is_showing:
		return
	GameManager.switch_character()
	if GameManager.active_player == "you":
		her.get_node("NavigationAgent2D").target_position = her.global_position
	else:
		player.get_node("NavigationAgent2D").target_position = player.global_position
	_tween_camera_to_active()
	_pulse_switch_button()

func _pulse_switch_button():
	# Brief scale pulse on the switch button as feedback
	var tween = create_tween()
	tween.tween_property(switch_button, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(switch_button, "scale", Vector2(1.0, 1.0), 0.15)

func _tween_camera_to_active():
	var target = player.global_position if GameManager.active_player == "you" else her.global_position
	var tween = create_tween()
	tween.tween_property(camera, "global_position", target, 0.4)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _process(delta):
	var target_pos = player.global_position if GameManager.active_player == "you" else her.global_position
	camera.global_position = lerp(camera.global_position, target_pos, delta * 6)
	_update_switch_button_glow()

func _update_switch_button_glow():
	# Pulse the switch button alpha so player knows it's always available
	var t = Time.get_ticks_msec() / 1000.0
	var pulse = 0.75 + 0.25 * sin(t * 2.5)
	switch_button.modulate.a = pulse

func show_room_name_for_index(index: int):
	_show_room_name(index)

func _show_room_name(index: int):
	var scene_path = RoomManager.rooms[index]
	# Extract filename without extension e.g. "room_1"
	var filename = scene_path.get_file().get_basename()
	var display = ROOM_NAMES.get(filename, "")
	if display == "":
		return
	room_name_label.text = display
	var tween = create_tween()
	tween.tween_property(room_name_label, "modulate:a", 1.0, 0.6)
	tween.tween_interval(2.0)
	tween.tween_property(room_name_label, "modulate:a", 0.0, 0.8)

func update_memory_counter():
	_update_memory_counter()

func _update_memory_counter():
	memory_counter.text = "✦ " + str(GameManager.memory_stones_found) + " / 3"

func fade_out():
	var tween = create_tween()
	tween.tween_property($HUD/FadeRect, "modulate:a", 1.0, 0.4)
	await tween.finished

func fade_in():
	var tween = create_tween()
	tween.tween_property($HUD/FadeRect, "modulate:a", 0.0, 0.4)
	await tween.finished

func _on_gallery_button_pressed():
	if DialogueManager.is_showing:
		return
	$HUD/GalleryOverlay.visible = true
	_populate_gallery()

func _populate_gallery():
	var all_items = {
		"book": "The Book",
		"flower": "The Flower",
	}
	var container = $HUD/GalleryOverlay/ItemContainer
	for child in container.get_children():
		child.queue_free()
	for item_id in all_items:
		var label = Label.new()
		if GameManager.collected_memories.has(item_id):
			label.text = "✦  " + all_items[item_id]
			label.modulate = Color("#e8e0f0")
		else:
			label.text = "?  Not yet found"
			label.modulate = Color("#3a3a5c")
		label.add_theme_font_size_override("font_size", 16)
		container.add_child(label)

func _on_gallery_close_pressed():
	$HUD/GalleryOverlay.visible = false
