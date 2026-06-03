# room_8.gd
extends Node2D

const SYMBOLS = ["✦", "◈", "⬡", "◉", "▲", "✿"]
const HINT_AFTER_TAPS = 8   # show hint after this many wrong taps

var target_a: String = ""
var target_b: String = ""
var current_a: String = ""
var current_b: String = ""
var is_solved = false
var tap_count = 0

@onready var lantern_a      = $LanternA
@onready var lantern_b      = $LanternB
@onready var label_a        = $LanternA/SymbolLabel
@onready var label_b        = $LanternB/SymbolLabel
@onready var target_label_a = $TargetA
@onready var target_label_b = $TargetB
@onready var hint_label     = $HintLabel
@onready var solved_label   = $SolvedLabel
@onready var exit_door      = $ExitDoor

func _ready():
	exit_door.monitoring = false
	exit_door.monitorable = false
	solved_label.visible = false

	target_a = SYMBOLS[randi() % SYMBOLS.size()]
	target_b = SYMBOLS[randi() % SYMBOLS.size()]
	current_a = SYMBOLS[0]
	current_b = SYMBOLS[0]

	target_label_a.text = target_a
	target_label_b.text = target_b
	label_a.text = current_a
	label_b.text = current_b

	lantern_a.interacted.connect(_on_lantern_a_tapped)
	lantern_b.interacted.connect(_on_lantern_b_tapped)

	await get_tree().create_timer(0.6).timeout
	DialogueManager.show_dialogue("room_starfield")

func _on_lantern_a_tapped():
	if is_solved or DialogueManager.is_showing:
		return
	current_a = _next_symbol(current_a)
	label_a.text = current_a
	tap_count += 1
	_check_hint()
	_check_solution()

func _on_lantern_b_tapped():
	if is_solved or DialogueManager.is_showing:
		return
	current_b = _next_symbol(current_b)
	label_b.text = current_b
	tap_count += 1
	_check_hint()
	_check_solution()

func _next_symbol(current: String) -> String:
	return SYMBOLS[(SYMBOLS.find(current) + 1) % SYMBOLS.size()]

func _check_hint():
	if tap_count == HINT_AFTER_TAPS:
		# Flash the correct target labels to give the player a nudge
		for lbl in [target_label_a, target_label_b]:
			var tween = create_tween()
			tween.tween_property(lbl, "modulate", Color(1.5, 1.5, 0.3, 1.0), 0.2)
			tween.tween_property(lbl, "modulate", Color(0.6, 0.6, 0.8, 1.0), 0.3)
			tween.tween_property(lbl, "modulate", Color(1.5, 1.5, 0.3, 1.0), 0.2)
			tween.tween_property(lbl, "modulate", Color(0.6, 0.6, 0.8, 1.0), 0.3)
		hint_label.text = "Match each lantern to the symbol above it."
		tap_count = 0  # reset so hint can fire again if needed

func _check_solution():
	if current_a == target_a and current_b == target_b:
		is_solved = true
		_on_solved()

func _on_solved():
	for lbl in [label_a, label_b]:
		var tween = create_tween()
		tween.tween_property(lbl, "modulate", Color(0.4, 1.0, 0.6, 1.0), 0.25)

	solved_label.visible = true
	solved_label.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(solved_label, "modulate:a", 1.0, 0.5)

	DialogueManager.show_dialogue("symbol_solved")
	DialogueManager.dialogue_closed.connect(_open_exit, CONNECT_ONE_SHOT)

func _open_exit():
	exit_door.monitoring = true
	exit_door.monitorable = true
	hint_label.text = "The way forward is open."
