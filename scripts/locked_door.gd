extends StaticBody2D

var player_nearby = false
var is_open = false

func _ready():
	$UnlockZone.body_entered.connect(_on_body_entered)
	$UnlockZone.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player") and not is_open:
		player_nearby = true
		_check_unlock()

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false

func _check_unlock():
	if GameManager.has_key and not is_open:
		is_open = true
		open_door()

func open_door():
	# Hide the visual door
	$CollisionShape2D.set_deferred("disabled", true)
	$ColorRect.visible = false
	$Label.visible = false
	print("Door unlocked — loading next room")
	# Wait one frame then go to next room
	await get_tree().process_frame
	RoomManager.go_to_next_room()
