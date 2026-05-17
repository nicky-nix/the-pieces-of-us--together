extends Area2D

signal switch_activated

var is_pressed = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("crate") and not is_pressed:
		is_pressed = true
		$SwitchSprite.color = Color("#00FF00")  # turns green when activated
		print("Switch activated!")
		emit_signal("switch_activated")

func _on_body_exited(body):
	if body.is_in_group("crate"):
		is_pressed = false
		$SwitchSprite.color = Color("#555555")  # turns grey again
