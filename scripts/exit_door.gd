# exit_door.gd
extends Area2D

signal exit_reached

var triggered = false

func _ready():
	body_entered.connect(_on_body_entered)
	monitoring = true
	monitorable = true

func _on_body_entered(body):
	# Ignore non-CharacterBody2D — stops TileMapLayer from triggering exit
	if not body is CharacterBody2D:
		return
	if not body.is_in_group("player"):
		return
	if triggered:
		return
	triggered = true
	emit_signal("exit_reached")
