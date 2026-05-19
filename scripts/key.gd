extends Area2D

var player_nearby = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	monitoring = true
	monitorable = true

func _on_body_entered(body):
	print("Key: body entered — ", body.name)
	if body.is_in_group("player"):
		player_nearby = true
		$PromptLabel.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
		$PromptLabel.visible = false

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if player_nearby:
			collect()
	if event is InputEventScreenTouch and not event.pressed:
		if player_nearby:
			collect()

func collect():
	GameManager.has_key = true
	print("Key collected!")
	queue_free()
