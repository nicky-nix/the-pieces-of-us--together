# exit_door.gd
extends Area2D

signal exit_reached

var triggered = false
var active = false  # stays false until _enable() is called after spawn delay

func _ready():
	body_entered.connect(_on_body_entered)
	monitoring = true
	monitorable = true
	# Wait 1 second after room loads before accepting any player
	# This prevents instant trigger on spawn
	await get_tree().create_timer(1.0).timeout
	active = true

func _on_body_entered(body):
	if not active:
		return
	if not body is CharacterBody2D:
		return
	if not body.is_in_group("player"):
		return
	if triggered:
		return
	triggered = true
	emit_signal("exit_reached")
