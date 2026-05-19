extends CharacterBody2D

const SPEED = 120.0

@onready var agent = $NavigationAgent2D
@onready var push_arrow = $PushArrow

var current_crate = null
var touching_crate = false

func _ready():
	await get_tree().physics_frame
	await get_tree().physics_frame
	push_arrow.visible = false

func _input(event):
	if DialogueManager.is_showing:
		return
	if not GameManager.active_player == "you":
		return
	if touching_crate:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		var world_pos = get_global_mouse_position()
		agent.target_position = world_pos
	if event is InputEventScreenTouch and not event.pressed:
		var world_pos = get_global_mouse_position()
		agent.target_position = world_pos

func _physics_process(_delta):
	if not GameManager.active_player == "you":
		velocity = Vector2.ZERO
		push_arrow.visible = false
		touching_crate = false
		return

	touching_crate = false
	current_crate = null

	if agent.is_navigation_finished():
		velocity = Vector2.ZERO
		push_arrow.visible = false
		return

	var next = agent.get_next_path_position()
	var dir = (next - global_position).normalized()
	velocity = dir * SPEED
	move_and_slide()

	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		if col == null:
			continue
		var body = col.get_collider()
		if body == null:
			continue
		if body.is_in_group("crate"):
			touching_crate = true
			current_crate = body
			velocity = Vector2.ZERO
			agent.target_position = global_position
			var push_dir = (body.global_position - global_position).normalized()
			push_arrow.visible = true
			push_arrow.rotation = push_dir.angle()
			if body.velocity.length() < 10.0:
				body.push(push_dir)
			break

	if not touching_crate:
		push_arrow.visible = false
		
func stop():
	velocity = Vector2.ZERO
	$NavigationAgent2D.target_position = global_position
