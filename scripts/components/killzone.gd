extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	print("You died lol") 
	
	# 1. Tell Godot to pause this specific code for 1.0 seconds
	await get_tree().create_timer(1.0).timeout
	
	# 2. Because we are still in the same function, Godot still remembers 'body'!
	if body.has_method("instant_death"):
		body.instant_death()
