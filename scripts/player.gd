# player.gd
extends CharacterBody2D

const SPEED = 120.0
const FOLLOW_DISTANCE = 55.0
const FOLLOW_THRESHOLD = 50.0
const FOLLOW_STOP_DIST = 45.0

@onready var anim  = $AnimatedSprite2D
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
	if GameManager.active_player != "you":
		return
	if touching_crate:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		var world_pos = get_global_mouse_position()
		agent.target_position = world_pos
		_spawn_destination_dot(world_pos)
	if event is InputEventScreenTouch and not event.pressed:
		var world_pos = get_viewport().get_canvas_transform().affine_inverse() * event.position
		agent.target_position = world_pos
		_spawn_destination_dot(world_pos)

func _spawn_destination_dot(pos: Vector2):
	var dot = ColorRect.new()
	dot.size = Vector2(8, 8)
	dot.color = Color(0.85, 0.8, 1.0, 0.9)
	dot.global_position = pos - Vector2(4, 4)
	get_tree().get_current_scene().add_child(dot)
	var tween = dot.create_tween()
	tween.tween_property(dot, "modulate:a", 0.0, 0.5)
	tween.tween_callback(dot.queue_free)

func _physics_process(_delta):
	push_arrow.visible = false

	if GameManager.active_player != "you":
		var main = get_tree().get_root().get_node_or_null("Main")
		if main:
			var her_node = main.get_node_or_null("Her")
			if her_node:
				var dist = global_position.distance_to(her_node.global_position)
				if dist < FOLLOW_STOP_DIST:
					velocity = Vector2.ZERO
					agent.target_position = global_position
				else:
					var her_dir = Vector2.ZERO
					if her_node.velocity.length() > 5.0:
						her_dir = her_node.velocity.normalized()
					else:
						her_dir = (her_node.global_position - global_position).normalized()
					var follow_target = her_node.global_position - her_dir * FOLLOW_DISTANCE
					agent.target_position = follow_target
					if agent.is_navigation_finished():
						velocity = Vector2.ZERO
					else:
						var next = agent.get_next_path_position()
						velocity = (next - global_position).normalized() * (SPEED * 0.9)
						move_and_slide()
		touching_crate = false
		current_crate = null
		# ── animate even when following ──
		_update_animation()
		return

	# ── active player ──
	touching_crate = false
	current_crate = null

	if agent.is_navigation_finished():
		velocity = Vector2.ZERO
		_update_animation()
		return

	var next = agent.get_next_path_position()
	velocity = (next - global_position).normalized() * SPEED
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

	_update_animation()

func _update_animation():
	if velocity.length() > 5:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				if anim.animation != "walk_right":
					anim.play("walk_right")
			else:
				if anim.animation != "walk_left":
					anim.play("walk_left")
		else:
			if velocity.y > 0:
				if anim.animation != "walk_down":
					anim.play("walk_down")
			else:
				if anim.animation != "walk_up":
					anim.play("walk_up")
	else:
		if anim.animation != "idle":
			anim.play("idle")

func stop():
	velocity = Vector2.ZERO
	$NavigationAgent2D.target_position = global_position
	if anim.animation != "idle":
		anim.play("idle")
