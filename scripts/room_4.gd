extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# ... existing room setup ...

	# Show room intro after a short delay (let fade-in begin first)
	await get_tree().create_timer(0.6).timeout
	DialogueManager.show_dialogue("room_hilltop")  # change ID per room


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
