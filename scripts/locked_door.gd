extends StaticBody2D

var is_open = false

func _ready():
	$UnlockZone.body_entered.connect(_on_body_entered)
	$UnlockZone.monitoring = true
	$UnlockZone.monitorable = true

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	if not is_open:
		# First visit — check for key
		if GameManager.has_key:
			_unlock()
		else:
			# No key — show locked message
			$Label.text = "🔒 Need a key"
	else:
		# Door already unlocked — go to next room
		print("Player entered unlocked door — loading next room")
		RoomManager.go_to_next_room()

func _unlock():
	is_open = true
	# Remove the physical block
	$CollisionShape2D.set_deferred("disabled", true)
	# Change visuals to show unlocked
	$ColorRect.color = Color("#22AA55")  # turns green
	$Label.text = "✦ Unlocked!"
	print("Door unlocked!")
