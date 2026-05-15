extends CharacterBody2D

const SPEED = 120.0

@onready var agent = $NavigationAgent2D
@onready var sprite = $Sprite   # your visual node

var last_dir = Vector2.DOWN

func _ready():
	# Wait one frame to ensure navigation regions are registered
	await get_tree().process_frame
	# Force the agent to use the world's navigation map
	agent.set_navigation_map(get_world_2d().navigation_map)
	print("Navigation agent ready")

func _input(event):
	# For desktop testing: mouse click. For mobile: touch.
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT) or (event is InputEventScreenTouch and not event.pressed):
		var target_pos = get_global_mouse_position()
		print("Target set to: ", target_pos)
		agent.target_position = target_pos

func _physics_process(delta):
	# Check if player is active (if using GameManager)
	# if not GameManager.active_player == "you": return
	
	if agent.is_navigation_finished():
		# No target or reached destination
		velocity = Vector2.ZERO
		return
	
	var next_path_position = agent.get_next_path_position()
	var direction = (next_path_position - global_position).normalized()
	
	# Optional: update facing direction for animations
	last_dir = direction
	
	velocity = direction * SPEED
	move_and_slide()
