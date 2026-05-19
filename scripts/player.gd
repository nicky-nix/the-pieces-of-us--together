extends CharacterBody2D

const SPEED = 120.0

@onready var agent = $NavigationAgent2D

func _ready():
	await get_tree().physics_frame
	await get_tree().physics_frame
	
func _input(event):
	if not GameManager.active_player == "you":
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		var world_pos = get_global_mouse_position()
		agent.target_position = world_pos
	if event is InputEventScreenTouch and not event.pressed:
		var world_pos = get_global_mouse_position()
		agent.target_position = world_pos

func _physics_process(delta):
	if not GameManager.active_player == "you":
		velocity = Vector2.ZERO
		return
	if agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	var next = agent.get_next_path_position()
	var dir = (next - global_position).normalized()
	velocity = dir * SPEED
	move_and_slide()

	# Push crate — only fire once per collision, not every frame
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider != null and collider.is_in_group("crate"):
			var push_dir = (collider.global_position - global_position).normalized()
			# Only push if crate is nearly stopped (prevents sticking)
			if collider.velocity.length() < 5.0:
				collider.push(push_dir)
