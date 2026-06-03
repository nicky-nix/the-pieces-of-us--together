# interactable.gd
# Attach to LanternA and LanternB (Area2D nodes).
# Emits "interacted" when the player is nearby and taps/clicks the lantern.

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

	# Mobile tap
	if event is InputEventScreenTouch and not event.pressed:
		var tap_pos = get_viewport().get_canvas_transform().affine_inverse() * event.position
		if global_position.distance_to(tap_pos) < 60:
			emit_signal("interacted")
			get_viewport().set_input_as_handled()

	# Desktop / editor mouse click — was missing entirely, this is why nothing happened
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		var mouse_pos = get_global_mouse_position()
		if global_position.distance_to(mouse_pos) < 60:
			emit_signal("interacted")
			get_viewport().set_input_as_handled()
