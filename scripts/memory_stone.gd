# memory_stone.gd
extends Area2D

@export var dialogue_id: String = "memory_stone_1"

var collected = false
var glow_tween: Tween = null

func _ready():
	body_entered.connect(_on_body_entered)
	_start_glow()

func _start_glow():
	if glow_tween:
		glow_tween.kill()
	glow_tween = create_tween().set_loops()
	if has_node("ColorRect"):
		glow_tween.tween_property($ColorRect, "modulate", Color(1.8, 0.6, 1.8, 1.0), 0.9)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		glow_tween.tween_property($ColorRect, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.9)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_body_entered(body):
	if collected:
		return
	if body.is_in_group("player"):
		collected = true
		if glow_tween:
			glow_tween.kill()
		GameManager.memory_stones_found += 1
		# Update memory counter in HUD
		var main = get_tree().get_root().get_node_or_null("Main")
		if main and main.has_method("update_memory_counter"):
			main.update_memory_counter()
		DialogueManager.show_dialogue(dialogue_id)
		await DialogueManager.dialogue_closed
		queue_free()
