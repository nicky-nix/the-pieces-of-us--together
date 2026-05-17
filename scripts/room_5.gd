extends Node2D

func _ready():
	# Lock the exit until switch is activated
	$ExitDoor/CollisionShape2D.disabled = true
	$PressureSwitch.switch_activated.connect(_on_switch_activated)

func _on_switch_activated():
	print("Exit unlocked!")
	$ExitDoor/CollisionShape2D.disabled = false
	# Make exit visible so player knows it opened
	$ExitDoor/ColorRect.color = Color("#00FF00")
