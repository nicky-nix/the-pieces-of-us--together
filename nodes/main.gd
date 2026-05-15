extends Node2D

@export var player1: Node2D
@export var player2: Node2D
@onready var camera: Camera2D = $GameCamera
@export var camera_offset: Vector2 = Vector2(0, -50)

@export var pan_duration: float = 0.4

var active_tween: Tween = null
var is_panning: bool = false

func _ready():
	var btn = $UI/TouchScreenButton
	if btn:
		btn.pressed.connect(_on_heart_pressed)
		print("Heart button connected.")
	else:
		print("ERROR: Heart button not found.")
	
	# Snap camera to starting active player immediately
	if GameManager.active_player == "player1" and player1:
		camera.global_position = player1.global_position + camera_offset
	elif player2:
		camera.global_position = player2.global_position + camera_offset
	
func _on_heart_pressed():
	print("Heart pressed!")
	if GameManager.active_player == "player1":
		GameManager.active_player = "player2"
	else:
		GameManager.active_player = "player1"
	
	_move_camera_to_active_player()
	_stop_inactive_player()

func _move_camera_to_active_player():
	var target = player1 if GameManager.active_player == "player1" else player2
	if not target:
		return
	if not camera:
		return
	
	if active_tween and active_tween.is_valid():
		active_tween.kill()
	
	is_panning = true
	active_tween = create_tween()
	active_tween.tween_property(camera, "global_position", target.global_position + camera_offset, pan_duration)	
	active_tween.set_trans(Tween.TRANS_SINE)
	active_tween.set_ease(Tween.EASE_IN_OUT)
	active_tween.finished.connect(_on_pan_finished)

func _on_pan_finished():
	is_panning = false

func _process(_delta: float) -> void:
	if is_panning:
		return
	
	var target = player1 if GameManager.active_player == "player1" else player2
	if target and camera:
		camera.global_position = target.global_position + camera_offset
		
func _stop_inactive_player():
	var inactive = player2 if GameManager.active_player == "player1" else player1
	if inactive and inactive is CharacterBody2D:
		inactive.velocity.x = 0
		
func _input(event):
	if event.is_action_pressed("switch"):   # Enter key
		_on_heart_pressed()    # This toggles and moves camera
