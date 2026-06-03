# room_6.gd
extends Node2D

func _ready():
	await get_tree().create_timer(0.6).timeout
	DialogueManager.show_dialogue("room_garden")
