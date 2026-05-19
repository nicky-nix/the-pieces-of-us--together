# memory_stone.gd
extends Area2D

@export var dialogue_id: String = "memory_stone_1"

var collected = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if collected:
		return
	if body.is_in_group("player"):
		collected = true
		GameManager.memory_stones_found += 1
		DialogueManager.show_dialogue(dialogue_id)
		# Optional: animate stone disappearing after dialogue closes
		await DialogueManager.dialogue_closed  # add this signal to DialogueManager
		queue_free()
