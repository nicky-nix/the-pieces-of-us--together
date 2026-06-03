# room_8.gd
# Attach to Room8 root Node2D — symbol match puzzle using LanternA and LanternB.

extends Node2D

const SYMBOLS = ["✦", "◈", "⬡", "◉", "▲", "✿"]

var target_a: String = ""
var target_b: String = ""
var current_a: String = ""
var current_b: String = ""
var is_solved = false

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
	# Lock exit until solved
	exit_door.monitoring = false
	exit_door.monitorable = false

	solved_label.visible = false

	# Random targets
	target_a = SYMBOLS[randi() % SYMBOLS.size()]
	target_b = SYMBOLS[randi() % SYMBOLS.size()]

	# Player starts on first symbol
	current_a = SYMBOLS[0]
	current_b = SYMBOLS[0]

	target_label_a.text = target_a
	target_label_b.text = target_b
	label_a.text = current_a
	label_b.text = current_b

	# Connect lantern taps
	lantern_a.interacted.connect(_on_lantern_a_tapped)
	lantern_b.interacted.connect(_on_lantern_b_tapped)

	# Room intro dialogue
	await get_tree().create_timer(0.6).timeout
	DialogueManager.show_dialogue("room_starfield")

func _on_lantern_a_tapped():
	if is_solved or DialogueManager.is_showing:
		return
	current_a = _next_symbol(current_a)
	label_a.text = current_a
	_check_solution()

func _on_lantern_b_tapped():
	if is_solved or DialogueManager.is_showing:
		return
	current_b = _next_symbol(current_b)
	label_b.text = current_b
	_check_solution()

func _next_symbol(current: String) -> String:
	var idx = SYMBOLS.find(current)
	return SYMBOLS[(idx + 1) % SYMBOLS.size()]

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
