extends CharacterBody2D

const FRICTION = 0.91      # was 0.80 — higher = slides further
const MIN_SPEED = 3.0        # unchanged

var is_being_pushed = false
var push_timer = 0.0

func _ready():
	# Wait one frame for the scene to be fully loaded
	await get_tree().physics_frame
	# Find Her and add her as a collision exception
	var main = get_tree().get_root().get_node_or_null("Main")
	if main:
		var her = main.get_node_or_null("Her")
		if her:
			add_collision_exception_with(her)
			print("Crate ignoring Her")

func _physics_process(delta):
	# Reduce push timer each frame
	if push_timer > 0:
		push_timer -= delta
		is_being_pushed = true
	else:
		is_being_pushed = false

	# Apply friction
	velocity = velocity * FRICTION

	# Hard stop when slow enough — this prevents sticking
	if velocity.length() < MIN_SPEED:
		velocity = Vector2.ZERO

	move_and_slide()

func push(direction: Vector2):
	if velocity.length() < 10.0:
		velocity = direction.normalized() * 220.0  # was 150 — stronger push
		push_timer = 0.1
