extends CharacterBody2D

@export var player_id: String = "player1"

@export var speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var gravity: float = 900.0

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# Only move if this player is active
	if GameManager.active_player == player_id:
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity
	else:
		# Inactive player slows to a stop
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
