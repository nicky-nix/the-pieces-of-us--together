extends Area2D

signal interacted

var player_nearby = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true
		if has_node("PromptLabel"):
			$PromptLabel.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
		if has_node("PromptLabel"):
			$PromptLabel.visible = false

func _input(event):
	if not player_nearby:
		return
	if DialogueManager.is_showing:
		return
	if event is InputEventScreenTouch and not event.pressed:
		# Check if the tap position is within this area's collision shape
		var tap_pos = get_viewport().get_canvas_transform().affine_inverse() * event.position
		var distance = global_position.distance_to(tap_pos)
		if distance < 60:  # tap within 60px of the lantern center
			emit_signal("interacted")
			get_viewport().set
