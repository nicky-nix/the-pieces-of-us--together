# memory_item.gd
extends Area2D

@export var item_id: String = "flower"
@export var dialogue_id: String = "flower_found"

var collected = false

func _ready():
	body_entered.connect(_on_body_entered)
	monitoring = true
	monitorable = true
	# This node needs to respond after dialogue closes even while paused
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_body_entered(body):
	if collected:
		return
	if body.is_in_group("player"):
		collected = true
		GameManager.collected_memories.append(item_id)
		# Show pickup dialogue, then disappear
		DialogueManager.show_dialogue(dialogue_id)
		DialogueManager.dialogue_closed.connect(_on_dialogue_done, CONNECT_ONE_SHOT)

func _on_dialogue_done():
	# Small float-up animation before disappearing
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(0, -20), 0.4)\
		.set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.4)
	await tween.finished
	queue_free()
