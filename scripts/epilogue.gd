# epilogue.gd
extends Node2D

# ── REPLACE THIS with her actual name ─────────────────────────────────────
const HER_NAME = "[Hyacinth]"
# ──────────────────────────────────────────────────────────────────────────

var final_lines = [
	"You cleared every room.",
	"Every puzzle was a memory.",
	"Every door we opened — together.",
	"",
	"I made this for you.",
	"Every line of code, every room, every word.",
	"",
	"Happy birthday.",
	HER_NAME + ".",
	"I love you."
]

var current_line = 0
var sequence_done = false

# Node names match your actual epilogue.tscn exactly
@onready var fade_rect     = $CanvasLayer/FadeRect
@onready var player_sprite = $Player
@onready var her_sprite    = $Her
@onready var message_label = $MessageLabel

func _ready():
	fade_rect.color = Color(0, 0, 0, 1.0)
	message_label.text = ""
	message_label.modulate.a = 0.0

	# Place characters off to each side
	player_sprite.position = Vector2(80, 400)
	her_sprite.position = Vector2(400, 400)

	_fade_in()

func _fade_in():
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, 1.2)
	await tween.finished
	await get_tree().create_timer(0.8).timeout
	_walk_together()

func _walk_together():
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
		# All lines done — end sequence
		await get_tree().create_timer(1.0).timeout
		sequence_done = true
		# Fade in a closing prompt if you have one
		# Otherwise just wait for tap/click to quit
		return

	var line = final_lines[current_line]
	current_line += 1

	if line == "":
		await get_tree().create_timer(0.8).timeout
		_show_next_line()
		return

	var tween = create_tween()
	tween.tween_property(message_label, "modulate:a", 0.0, 0.3)
	await tween.finished
	message_label.text = line
	tween = create_tween()
	tween.tween_property(message_label, "modulate:a", 1.0, 0.5)
	await tween.finished

	await get_tree().create_timer(2.2).timeout
	_show_next_line()

func _input(event):
	if not sequence_done:
		return
	# Tap or click after sequence ends → fade to black and quit
	if event is InputEventScreenTouch and not event.pressed:
		_end_game()
	if event is InputEventMouseButton and event.pressed:
		_end_game()

func _end_game():
	sequence_done = false
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 1.0, 1.0)
	await tween.finished
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
