extends CharacterBody2D

const PUSH_SPEED = 90.0
const FRICTION = 0.85

func _physics_process(delta):
	# Apply friction every frame so crate slows to a stop
	velocity = velocity * FRICTION
	
	# Stop completely when moving very slowly
	if velocity.length() < 2.0:
		velocity = Vector2.ZERO
	
	move_and_slide()

func push(direction: Vector2):
	# Only accept a new push if crate is nearly stopped
	# This prevents sticking — player pushes once, crate slides away
	velocity = direction.normalized() * PUSH_SPEED
