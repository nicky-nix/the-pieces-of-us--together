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
	# Move players to start position after room loads
	await get_tree().process_frame
	_move_players_to_start()

func _move_players_to_start():
	player.global_position = Vector2(240, 400)
	her.global_position = Vector2(280, 400)

func _on_switch_button_pressed():
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
