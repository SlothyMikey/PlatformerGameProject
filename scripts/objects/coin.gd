extends Area2D

@onready var game_manager: Node = $"../../Game Manager"

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_coin"):
		body.add_coin()
	game_manager.add_point()
	queue_free() # Replace with function body.
