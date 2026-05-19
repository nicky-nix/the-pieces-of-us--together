extends Area2D

signal exit_reached

func _ready():
	body_entered.connect(_on_body_entered)
	print("ExitDoor ready — monitoring bodies")

func _on_body_entered(body):
	print("Something entered ExitDoor: ", body.name, " groups: ", body.get_groups())
	if body.is_in_group("player"):
		emit_signal("exit_reached")
