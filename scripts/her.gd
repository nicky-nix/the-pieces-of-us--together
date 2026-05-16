extends CharacterBody2D

const SPEED = 120.0

@onready var agent = $NavigationAgent2D
@onready var light = $PointLight2D  # ADD THIS LINE

func _ready():
	await get_tree().physics_frame
	await get_tree().physics_frame
	light.visible = false  # ADD THIS — light off at start

func _input(event):
	if not GameManager.active_player == "her":
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		var world_pos = get_global_mouse_position()
		agent.target_position = world_pos
	if event is InputEventScreenTouch and not event.pressed:
		var world_pos = get_global_mouse_position()
		agent.target_position = world_pos

func _physics_process(delta):
	# Light follows active player state every frame
	light.visible = (GameManager.active_player == "her")  # ADD THIS LINE

	if not GameManager.active_player == "her":
		velocity = Vector2.ZERO
		return
	if agent.is_navigation_finished():
		return
	var next = agent.get_next_path_position()
	var dir = (next - global_position).normalized()
	velocity = dir * SPEED
	move_and_slide()
