# her.gd
extends CharacterBody2D

const SPEED = 120.0
const FOLLOW_DISTANCE = 55.0
const FOLLOW_THRESHOLD = 50.0
const FOLLOW_STOP_DIST = 45.0

@onready var agent = $NavigationAgent2D
@onready var light  = $PointLight2D
@onready var anim   = $AnimatedSprite2D

var last_direction = "down"

func _ready():
	await get_tree().physics_frame
	await get_tree().physics_frame
	light.visible = false

func _input(event):
	if DialogueManager.is_showing:
		return
	if GameManager.active_player != "her":
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
	dot.color = Color(1.0, 0.75, 0.9, 0.9)
	dot.global_position = pos - Vector2(4, 4)
	get_tree().get_current_scene().add_child(dot)
	var tween = dot.create_tween()
	tween.tween_property(dot, "modulate:a", 0.0, 0.5)
	tween.tween_callback(dot.queue_free)

func _physics_process(_delta):
	light.visible = (GameManager.active_player == "her")

	if GameManager.active_player != "her":
		var main = get_tree().get_root().get_node_or_null("Main")
		if main:
			var player_node = main.get_node_or_null("Player")
			if player_node:
				var dist = global_position.distance_to(player_node.global_position)
				if dist < FOLLOW_STOP_DIST:
					velocity = Vector2.ZERO
					agent.target_position = global_position
				else:
					var player_dir = Vector2.ZERO
					if player_node.velocity.length() > 5.0:
						player_dir = player_node.velocity.normalized()
					else:
						player_dir = (player_node.global_position - global_position).normalized()
					var follow_target = player_node.global_position - player_dir * FOLLOW_DISTANCE
					agent.target_position = follow_target
					if agent.is_navigation_finished():
						velocity = Vector2.ZERO
					else:
						var next = agent.get_next_path_position()
						velocity = (next - global_position).normalized() * (SPEED * 0.9)
						move_and_slide()
		_update_animation()
		return

	# ── active player ──
	if agent.is_navigation_finished():
		velocity = Vector2.ZERO
		_update_animation()
		return

	var next = agent.get_next_path_position()
	velocity = (next - global_position).normalized() * SPEED
	move_and_slide()
	_update_animation()

func _update_animation():
	if velocity.length() > 5:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				last_direction = "right"
				if anim.animation != "walk_right":
					anim.play("walk_right")
			else:
				last_direction = "left"
				if anim.animation != "walk_left":
					anim.play("walk_left")
		else:
			if velocity.y > 0:
				last_direction = "down"
				if anim.animation != "walk_down":
					anim.play("walk_down")
			else:
				last_direction = "up"
				if anim.animation != "walk_up":
					anim.play("walk_up")
	else:
		# Single idle frame — no directional idles needed
		if anim.animation != "idle":
			anim.play("idle")

func stop():
	velocity = Vector2.ZERO
	$NavigationAgent2D.target_position = global_position
	if anim.animation != "idle":
		anim.play("idle")
