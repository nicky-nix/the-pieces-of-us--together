extends Node2D

@onready var camera = $Camera2D
@onready var player = $Player
@onready var her = $Her

func _ready():
	camera.global_position = player.global_position

func _on_switch_button_pressed():
	GameManager.switch_character()
	# Freeze the inactive character exactly where they are
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
