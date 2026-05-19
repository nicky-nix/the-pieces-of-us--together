# epilogue.gd
extends Node2D

# Your final personal lines — write these yourself, for real
var final_lines = [
	"You cleared every room.",
	"Every puzzle was a memory.",
	"Every door we opened — together.",
	"",
	"I made this for you.",
	"Every line of code, every room, every word.",
	"",
	"Happy birthday.",
	"[her name].",
	"I love you."
]

var current_line = 0

@onready var fade_rect = $CanvasLayer/FadeRect
@onready var player_sprite = $PlayerSprite
@onready var her_sprite = $HerSprite
@onready var message_label = $MessageLabel

func _ready():
	# Start hidden
	fade_rect.color = Color(0, 0, 0, 1.0)
	message_label.text = ""
	message_label.modulate.a = 0.0

	# Place characters off to each side
	player_sprite.position = Vector2(80, 400)
	her_sprite.position = Vector2(400, 400)

	# Begin sequence
	_fade_in()

func _fade_in():
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, 1.2)
	await tween.finished
	await get_tree().create_timer(0.8).timeout
	_walk_together()

func _walk_together():
	# Both characters walk toward center
	var tween = create_tween().set_parallel(true)
	tween.tween_property(player_sprite, "position", Vector2(190, 400), 2.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(her_sprite, "position", Vector2(290, 400), 2.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	await get_tree().create_timer(0.6).timeout
	_show_next_line()

func _show_next_line():
	if current_line >= final_lines.size():
		return

	var line = final_lines[current_line]
	current_line += 1

	if line == "":
		# Empty line = pause between sections
		await get_tree().create_timer(0.8).timeout
		_show_next_line()
		return

	# Fade label out, change text, fade back in
	var tween = create_tween()
	tween.tween_property(message_label, "modulate:a", 0.0, 0.3)
	await tween.finished
	message_label.text = line
	tween = create_tween()
	tween.tween_property(message_label, "modulate:a", 1.0, 0.5)
	await tween.finished

	# Wait, then show next line
	await get_tree().create_timer(2.2).timeout
	_show_next_line()
