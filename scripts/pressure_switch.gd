extends Area2D

signal switch_activated

var is_pressed = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	monitoring = true
	monitorable = true

func _on_body_entered(body):
	print("Pressure switch: body entered — ", body.name, " groups: ", body.get_groups())
	if body.is_in_group("crate") and not is_pressed:
		is_pressed = true
		# Turn green
		$SwitchSprite.color = Color("#00FF00")
		print("Switch activated!")
		emit_signal("switch_activated")

func _on_body_exited(body):
	if body.is_in_group("crate"):
		# Only deactivate if crate fully leaves
		await get_tree().physics_frame
		if not has_overlapping_bodies():
			is_pressed = false
			$SwitchSprite.color = Color("#555555")
