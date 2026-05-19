extends Node2D

var solution = ["lantern_a", "lantern_b"]
var activation_order = []
var solved = false

func _ready():
	$ExitDoor.monitoring = false
	$LanternA.interacted.connect(func(): _on_tapped("lantern_a", $LanternA))
	$LanternB.interacted.connect(func(): _on_tapped("lantern_b", $LanternB))
	await get_tree().create_timer(0.6).timeout
	DialogueManager.show_dialogue("room_starfield")

func _on_tapped(id: String, node: Node):
	if solved:
		return
	# Block taps during dialogue
	if DialogueManager.is_showing:
		return
	activation_order.append(id)
	node.get_node("ColorRect").color = Color("#FFD700")
	if activation_order.size() == solution.size():
		if activation_order == solution:
			_solve()
		else:
			_reset_wrong()

func _solve():
	solved = true
	$ExitDoor.monitoring = true
	$ExitDoor/ColorRect.color = Color("#22AA55")
	DialogueManager.show_dialogue("symbol_solved")

func _reset_wrong():
	# Don't await here — just use a timer signal instead to avoid state issues
	var t = get_tree().create_timer(0.5)
	t.timeout.connect(func():
		activation_order = []
		$LanternA/ColorRect.color = Color("#888888")
		$LanternB/ColorRect.color = Color("#888888")
	)
