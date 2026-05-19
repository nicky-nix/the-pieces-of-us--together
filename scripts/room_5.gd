extends Node2D

var exit_unlocked = false

func _ready():
	# Lock the exit at start
	var exit = $ExitDoor
	exit.monitoring = false
	
	# Connect switch
	var switch = $PressureSwitch
	if switch:
		switch.switch_activated.connect(_on_switch_activated)
		
	await get_tree().create_timer(0.6).timeout
	DialogueManager.show_dialogue("room_rainy")

func _on_switch_activated():
	if exit_unlocked:
		return
	exit_unlocked = true
	print("Exit unlocked by switch!")
	# Turn exit door green so player knows it opened
	$ExitDoor/ColorRect.color = Color("#00FF00")
	# Now allow the exit to detect players
	$ExitDoor.monitoring = true
