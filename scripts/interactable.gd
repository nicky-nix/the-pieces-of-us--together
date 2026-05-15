extends Area2D

signal interacted

var player_nearby = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	# Connect the input_event signal – this fires when the area itself is tapped/clicked
	input_event.connect(_on_interact)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true
		$PromptLabel.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
		$PromptLabel.visible = false

func _on_interact(viewport, event, shape_idx):
	# Check for left mouse click (desktop) OR touch release (mobile)
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT) or (event is InputEventScreenTouch and not event.pressed):
		if player_nearby:
			print("interacted!")
			emit_signal("interacted")
