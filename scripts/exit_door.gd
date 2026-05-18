extends Area2D

signal exit_reached

var triggered = false

func _ready():
	body_entered.connect(_on_body_entered)
	monitoring = true
	monitorable = true
	print("ExitDoor ready — triggered state: ", triggered)

func _on_body_entered(body):
	print("ExitDoor hit by: ", body.name, " | triggered: ", triggered, " | groups: ", body.get_groups())
	if body.is_in_group("player") and not triggered:
		triggered = true
		emit_signal("exit_reached")
