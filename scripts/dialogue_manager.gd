extends CanvasLayer

signal dialogue_closed

@export var typewriter_speed: float = 0.03

var is_showing = false
var current_lines = []
var current_index = 0

@onready var box = $DialogueBox
@onready var label = $DialogueBox/Label
@onready var timer = $TypewriterTimer

var full_text = ""
var revealed = ""

var dialogue_db = {
	"memory_stone_1": [
		"The first time I realised...",
		"...I wasn't ready to say it out loud.",
		"But I knew."
	],
	"memory_stone_2": [
		"There's a moment I keep coming back to.",
		"You didn't do anything special.",
		"You were just... you. And that was everything."
	],
	"memory_stone_3": [
		"Happy birthday.",
		"I built this whole world for you.",
		"Every room is a piece of us. Together."
	],
	"room_cafe": ["I remember this place. You were nervous. So was I. Neither of us admitted it."],
	"room_dark": ["It's dark in here. Stay close."],
	"room_library": ["You borrowed a book from me once. I wonder if you remember which one."],
	"room_hilltop": ["We walked with no destination. That was enough."],
	"room_rainy": ["You were sad that day. I didn't know what to say, so I just stayed."],
	"room_garden": ["There are small things I notice about you. You don't know I notice them."],
	"room_attic": ["You told me something here. I've kept it ever since."],
	"room_starfield": ["I have a wish for you. I'll tell you at the end."],
	"key_found": ["A key. Something is waiting to be opened."],
	"flower_found": ["A small thing. But it made me think of you."],
	"book_found": ["The book I lent you. I wonder if you ever finished it."],
	"symbol_solved": ["Something clicked. The way forward is open."],
	"room_dark_hint": ["Only she can find the way out. Switch to Her."],
}

func _ready():
	box.visible = false
	# Timer signal — make sure only this connection exists
	

func show_dialogue(trigger_id: String):
	if not dialogue_db.has(trigger_id):
		print("WARNING: dialogue_id not found: ", trigger_id)
		return
	current_lines = dialogue_db[trigger_id]
	current_index = 0
	is_showing = true
	box.visible = true
	_show_line(current_lines[0])

func _show_line(text: String):
	full_text = text
	revealed = ""
	label.text = ""
	timer.wait_time = typewriter_speed 
	timer.start()

func _on_timer_timeout():
	if revealed.length() < full_text.length():
		revealed += full_text[revealed.length()]
		label.text = revealed
	else:
		timer.stop()

func _input(event):
	if not is_showing:
		return
	if event is InputEventScreenTouch and not event.pressed:
		_advance()
	if event is InputEventMouseButton and event.pressed:
		_advance()

func _advance():
	if revealed.length() < full_text.length():
		revealed = full_text
		label.text = full_text
		timer.stop()
		return
	current_index += 1
	if current_index >= current_lines.size():
		_close()
	else:
		_show_line(current_lines[current_index])

func _close():
	is_showing = false
	box.visible = false
	emit_signal("dialogue_closed")
