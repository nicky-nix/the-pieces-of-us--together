# interactable.gd
extends Area2D

signal interacted

var player_nearby = false
var glow_tween: Tween = null

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	# Start glow pulse immediately so player knows it's interactable
	_start_glow()

func _start_glow():
	if glow_tween:
		glow_tween.kill()
	glow_tween = create_tween().set_loops()
	# Pulse the ColorRect (the visible part of the lantern) between normal and bright
	if has_node("ColorRect"):
		glow_tween.tween_property($ColorRect, "modulate", Color(1.4, 1.4, 0.6, 1.0), 0.8)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		glow_tween.tween_property($ColorRect, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.8)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _stop_glow():
	if glow_tween:
		glow_tween.kill()
		glow_tween = null
	if has_node("ColorRect"):
		$ColorRect.modulate = Color(1.0, 1.0, 1.0, 1.0)

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
			_stop_glow()
			emit_signal("interacted")
			get_viewport().set_input_as_handled()

	# Desktop mouse click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if global_position.distance_to(get_global_mouse_position()) < 60:
			_stop_glow()
			emit_signal("interacted")
			get_viewport().set_input_as_handled()
