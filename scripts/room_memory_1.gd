# room_memory_1.gd
extends Node2D

func _ready():
	await get_tree().create_timer(0.6).timeout
	# MemoryStone triggers its own dialogue when touched
	# This just handles the ExitDoor — it stays LOCKED until the stone is collected
	var stone = $MemoryStone
	if stone:
		stone.dialogue_id = "memory_stone_1"

	# Lock exit until stone is collected
	var exit = $ExitDoor
	exit.monitoring = false
	exit.monitorable = false

	# Wait for stone to be collected, then open exit
	$MemoryStone.tree_exited.connect(_on_stone_collected)

func _on_stone_collected():
	var exit = $ExitDoor
	exit.monitoring = true
	exit.monitorable = true
	exit.get_node("ColorRect").color = Color("#00FF00")
	print("Memory stone 1 collected — exit open")
