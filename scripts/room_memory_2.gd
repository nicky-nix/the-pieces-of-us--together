# room_memory_2.gd
extends Node2D

func _ready():
	await get_tree().create_timer(0.6).timeout
	var stone = $MemoryStone
	if stone:
		stone.dialogue_id = "memory_stone_2"

	var exit = $ExitDoor
	exit.monitoring = false
	exit.monitorable = false

	$MemoryStone.tree_exited.connect(_on_stone_collected)

func _on_stone_collected():
	var exit = $ExitDoor
	exit.monitoring = true
	exit.monitorable = true
	exit.get_node("ColorRect").color = Color("#00FF00")
	print("Memory stone 2 collected — exit open")
