extends Node2D

@onready var camera = $Camera2D
@onready var player = $Player
@onready var her = $Her
@onready var room_container = $RoomContainer

func _ready():
	RoomManager.room_container = room_container
	RoomManager.start_run()
	player.z_index = 10
	her.z_index = 10
	camera.global_position = player.global_position
	# Gallery starts hidden
	$HUD/GalleryOverlay.visible = false
	await get_tree().process_frame
	_move_players_to_start()

func _move_players_to_start():
	player.global_position = Vector2(240, 400)
	her.global_position = Vector2(280, 400)
	player.get_node("NavigationAgent2D").target_position = player.global_position
	her.get_node("NavigationAgent2D").target_position = her.global_position
	#velocity = Vector2.ZERO  # if player.gd exposes velocity directly

func _on_switch_button_pressed():
	# Block during dialogue
	if DialogueManager.is_showing:
		return
	# ONE call only — was incorrectly called twice before
	GameManager.switch_character()
	if GameManager.active_player == "you":
		her.get_node("NavigationAgent2D").target_position = her.global_position
	else:
		player.get_node("NavigationAgent2D").target_position = player.global_position
	_tween_camera_to_active()

func _tween_camera_to_active():
	var target
	if GameManager.active_player == "you":
		target = player.global_position
	else:
		target = her.global_position
	var tween = create_tween()
	tween.tween_property(camera, "global_position", target, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

func _process(delta):
	var target_pos
	if GameManager.active_player == "you":
		target_pos = player.global_position
	else:
		target_pos = her.global_position
	camera.global_position = lerp(camera.global_position, target_pos, delta * 6)

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
